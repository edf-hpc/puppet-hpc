#!/usr/bin/env ruby
##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
#  Contact: CCN-HPC <dsp-cspit-ccn-hpc@edf.fr>                           #
#                                                                        #
#  This program is free software; you can redistribute in and/or         #
#  modify it under the terms of the GNU General Public License,          #
#  version 2, as published by the Free Software Foundation.              #
#  This program is distributed in the hope that it will be useful,       #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#  GNU General Public License for more details.                          #
##########################################################################

require 'hiera'
require 'ipaddr'
require 'facter/hostname'
require 'hpc/ha'  # get_vips()

$options = {
  :default => nil,
  :config => File.join(Hiera::Util.config_dir, 'puppet/hiera.yaml'),
  :scope => {
    'environment' => Puppet[:environment],
    'cluster_name' => Facter.value(:cluster_name),
  },
  :key => nil,
  :verbose => false,
  :resolution_type => :priority
}

begin
  $hiera = Hiera.new(:config => $options[:config])

  rescue Exception => e
  if $options[:verbose]
    raise
  else
    STDERR.puts "Failed to start Hiera: #{e.class}: #{e}"
    exit 1
  end
end

unless $options[:verbose]
  Hiera.logger = "noop"
end

########################################

# override IPAddr class to add prefix method 
class IPAddr
  def prefix
    if @addr
      # count the number of 1 in binary repr of addr mask
      @mask_addr.to_s(2).count('1')
    else
      nil
    end
  end

  def subnets
    if prefix < 16
      STDERR.puts "Unable to calc /24 subnets on networks with cidr prefix #{prefix} < 16"
      return []
    elsif prefix >= 24
      return [ self ]
    end

    begin_addr_i = (@addr & @mask_addr)

    case @family
    when Socket::AF_INET
      end_addr_i = (@addr | (IN4MASK ^ @mask_addr))
    when Socket::AF_INET6
      end_addr_i = (@addr | (IN6MASK ^ @mask_addr))
    else
      raise "unsupported address family"
    end

    begin_addr = clone.set(begin_addr_i, @family)
    end_addr = clone.set(end_addr_i, @family)

    # FIXME: Starting from here, the logic really sucks and only works on ipv4
    # networks whose CIDR prefix is between 16 and 24.

    subnets_a = Array.new()

    network_number = begin_addr.to_s.split('.')[0..1]

    first_subnet = begin_addr.to_s.split('.')[2].to_i
    last_subnet  = end_addr.to_s.split('.')[2].to_i

    (first_subnet..last_subnet).each do |subnet_idx|
      subnet_s = [network_number, subnet_idx, '0'].flatten.join('.')
      subnet = IPAddr.new("#{subnet_s}/24")
      subnets_a << subnet
    end

    return subnets_a

  end
end

class DNSEntry

  attr_reader :owner, :proto, :type, :data

  def initialize(owner, proto, type, data)
    @owner = owner
    @proto = proto
    @type = type
    @data = data
  end

end

class DNSZone

  attr_reader :base
  attr_accessor :net
  attr_reader :entries

  def initialize(base)
    @base = base
    @net = nil # opt attr, ipaddr of reverse zone's network
    @entries = Array.new
  end

  def add_entry(owner, proto, type, data)
    @entries << DNSEntry.new(owner, proto, type, data)
  end

  def dump()
    result = Hash.new
    result['type'] = 'master'
    result['entries'] = Array.new
    @entries.each do |entry|
      result['entries'] << { 'owner' => entry.owner,
                             'proto' => entry.proto,
                             'type'  => entry.type,
                             'data'  => entry.data }
    end
    return result
  end
end

def get_hiera(key)
  return $hiera.lookup(key,
                       $options[:default],
                       $options[:scope],
                       nil,
                       $options[:resolution_type])
end

def get_local_domain()
  return get_hiera('local_domain')
end

def get_master_network()
  return get_hiera('master_network')
end

def get_network_topology()
  return get_hiera('net_topology')
end

# Returns the array of IPAddr to consider for reverse zones out of the network
# topology given in parameter.
def get_networks_reverse_zones(nets_topo)

  networks = Array.new

  nets_topo.each do |net_name, params|

    addr = params['ipnetwork']
    # get cidr prefix length w/o leading slash and convert to int
    prefix = params['prefix_length'][1..-1]
    cidr = "#{addr}/#{prefix}"
    ipnet = IPAddr.new(cidr)
    # get all /24 subnets of this network
    subnets = ipnet.subnets

    subnets.each do |subnet|
      # Check if network is not already included in any other networks
      add_network = true
      networks.each do |network|
        add_network = false if network.include?(subnet)
      end
      networks << subnet if add_network
    end

  end
  return networks 

end

# Returns the reverse zone name corresponding to an ipaddr. Ex:
#    192.168.0.0/16 -> 168.192.in-addr.arpa
#    192.168.3.1/24 - 1.168.192.in-addr.arpa
def get_reverse_zone_name(ip)
  leading_null = (32 - ip.prefix) / 8
  return ip.reverse.split('.')[leading_null..-1].join('.')
end

# Returns the reverse zone entry owner inside the network. Ex:
#    ip = 192.168.1.3 and net = 192.168.0.0/16 -> 3.1
#    ip = 192.168.1.3 and net = 192.168.1.0/24 -> 3
def get_reverse_zone_owner(ip, net)
  trailing_bytes = (32 - net.prefix) / 8
  return ip.to_s.split('.').reverse[0..trailing_bytes-1].join('.')
end

def find_reverse_zone(zones, ip) 
  zones.each do |zone|
    if zone.net.include?(ip)
      return zone
    end
  end
  return nil
end

def add_entries(local_zone, reverse_zones, hostname, fqdn, ip)
  local_zone.add_entry(hostname, 'IN', 'A', ip.to_s)
  reverse_zone = find_reverse_zone(reverse_zones, ip)
  if reverse_zone.nil?
    puts("unable to find reverse zone for IP #{ip.to_s}")
    # do nothing
  else
    owner = get_reverse_zone_owner(ip, reverse_zone.net)
    reverse_zone.add_entry(owner, 'IN', 'PTR', fqdn)
  end
end

def hpc_dns_zones()

  local_domain = get_local_domain()
  local_zone = DNSZone.new(local_domain)
  reverse_zones = Array.new

  net_topo = get_network_topology()
  networks = get_networks_reverse_zones(net_topo)

  # add NS to local zone
  hostname = Facter.value(:hostname)
  fqdn = "#{hostname}.#{local_domain}."
  local_zone.add_entry('@', 'IN', 'NS', fqdn)
  local_zone.add_entry('@', 'IN', 'A', '127.0.0.1')

  # create a reverse zone for each network

  networks.each do |network|
    zone_name = get_reverse_zone_name(network)
    reverse_zone = DNSZone.new(zone_name)
    reverse_zone.net = network
    reverse_zone.add_entry('@', 'IN', 'NS', fqdn)
    reverse_zones << reverse_zone
  end

  # add cluster hosts to zones

  mn = get_master_network()
  
  mn.each do |host, details|
    netifs = details['networks']
    netifs.each do |network, params|
      hostname = params['hostname']
      ip = IPAddr.new(params['IP'])
      # On the WAN network, take the FQDN of the node instead of its
      # hostname+local_domain for the reverse in order to get same response
      # with DNS servers inside and outside the cluster.
      if network == 'wan'
        fqdn = "#{details['fqdn']}."
      else
        fqdn = "#{hostname}.#{local_domain}."
      end
      add_entries(local_zone, reverse_zones, hostname, fqdn, ip)
    end
  end

  # add vips to zones

  vips = get_vips()

  vips.each do |vip, params|
    hostname = params['hostname']
    ip = IPAddr.new(params['ip'])
    fqdn = "#{hostname}.#{local_domain}."
    add_entries(local_zone, reverse_zones, hostname, fqdn, ip)
  end

  # dump everything into zones big hash

  zones = Hash.new
  zones[local_zone.base] = local_zone.dump
  reverse_zones.each do |reverse_zone|
    zones[reverse_zone.base] = reverse_zone.dump
  end

  return zones

end
