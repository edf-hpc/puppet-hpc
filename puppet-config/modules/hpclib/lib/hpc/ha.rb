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
require 'facter/hostname'
require 'hpc/nodeset'  # hpc_nodeset_expand()
require 'hpc/profiles' # get_cluster_prefix()

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

# Return the vips hash found in hiera
def get_vips()
  key = 'vips'
  vips = $hiera.lookup(key,
                       $options[:default],
                       $options[:scope],
                       nil,
                       $options[:resolution_type])
  return vips
end

def get_host_vips(hostname)

  # This function returns a hash that could be given in parameters of:
  #   create_resources(hpc_ha::vip, $result)

  host_vips = Hash.new
  prefix = get_cluster_prefix()

  # Iterate over all VIPs found in hiera. For each of them, if hostname is
  # member, add to host_vips
  all_vips = get_vips()
  all_vips.each do |vip_group, vip_items|

    members = hpc_nodeset_expand(vip_items['members'])
    if members.include?(hostname)

      is_master = vip_items['master'] == hostname
      priority = is_master ? 100 : 50

      new_vip = Hash.new
      # The items in this hash must correspond to the parameters of the
      # hpc_ha::vip class
      new_vip['prefix'] = prefix
      new_vip['master'] = is_master
      new_vip['priority'] = priority
      new_vip['net_id'] = vip_items['network']
      new_vip['router_id'] = vip_items['router_id']
      new_vip['ip_address'] = vip_items['ip']
      new_vip['auth_secret'] = vip_items['secret']
      new_vip['notify_script'] = vip_items.key?('notify')
      if vip_items.key?('advert_int')
        new_vip['advert_int'] = vip_items['advert_int']
      end

      host_vips[vip_group] = new_vip
    end
  end
  return nil unless host_vips.length
  return host_vips
end

def get_host_vip_notify_scripts(hostname)

  # This function returns a hash that could be given in parameters of:
  #   create_resources(hpc_ha::vip_notify_script, $result)
  #
  # It implies that the items in the hashes composing this hash must correspond
  # to the parameters of the hpc_ha::vip_notify_script class.

  host_vip_notify_scripts = Hash.new

  # Iterate over all VIPs found in hiera. For each of them, if hostname is
  # member, add to host_vips

  all_vips = get_vips()
  all_vips.each do |vip_name, vip_items|

    members = hpc_nodeset_expand(vip_items['members'])
    if members.include?(hostname) and vip_items.key?('notify')

      notify_conf = vip_items['notify']

      # If the notify element is a simple string, consider the value is the
      # source of a script in common part.
      if notify_conf.instance_of? String
        new_script = Hash.new
        new_script['vip_name'] = vip_name
        new_script['part'] = 'common'
        source = vip_items['notify']
        basename = File.basename(source)
        new_script['source'] = source
        host_vip_notify_scripts["#{vip_name}-common-#{basename}"] = new_script
      else
        # Otherwise (not a string), the notify element must a a hash, with parts
        # as keys, of list of script sources.
        notify_conf.each do |part, scripts|
          scripts.each do |source|
            new_script = Hash.new
            new_script['vip_name'] = vip_name
            new_script['part'] = part
            basename = File.basename(source)
            new_script['source'] = source
            host_vip_notify_scripts["#{vip_name}-#{part}-#{basename}"] = new_script
          end
        end
      end

    end
  end
  return nil unless host_vip_notify_scripts.length
  return host_vip_notify_scripts
end

def get_host_vservs(hostname)
  
  # This function returns a hash that could be given in parameters of:
  #   create_resources(hpc_ha::vservs, $result)

  host_vservs = Hash.new

  # Find prefix for construct real hostname, for example if VIP is on "wan" real hostname isn't fbfront1 but wanfbfront1
  net_topology = Facter.value(:net_topology)

  # Iterate over all VIPs found in hiera. For each of them, if hostname is
  # member, add to host_vips
  all_vservs = get_vips()
  all_vservs.each do |vservs_group, vservs_items|

    members = hpc_nodeset_expand(vservs_items['members'])
    network_type = vservs_items['network']
    netmask = net_topology[network_type]['prefix_length']
    ip = vservs_items['ip']
    ip2 = "#{ip}#{netmask}"

    if members.include?(hostname) and vservs_items.key?('port')
      new_vservs = Hash.new
      # The items in this hash must correspond to the parameters of the
      # hpc_ha::vserv class
      new_vservs['vip_name'] = vservs_group
      new_vservs['ip_address'] = ip2
      new_vservs['port'] = vservs_items['port']
      new_vservs['real_server_hosts'] = members
      new_vservs['delay_loop'] = vservs_items['delay_loop']
      new_vservs['persistence_timeout'] = vservs_items['persistence_timeout']
      new_vservs['protocol'] = vservs_items['protocol']
      new_vservs['options'] = Hash.new
      new_vservs['options'] = vservs_items['options']
      new_vservs['network'] = vservs_items['network']
      new_vservs['prefixes'] = net_topology[network_type]['prefixes']
      host_vservs[vservs_group] = new_vservs
    end
  end

  return nil unless host_vservs.length
  return host_vservs
end

def hpc_ha_vips()
  hostname = Facter.value(:hostname)
  return get_host_vips(hostname)
end

def hpc_ha_vip_notify_scripts()
  hostname = Facter.value(:hostname)
  return get_host_vip_notify_scripts(hostname)
end

def hpc_ha_vservs()
  hostname = Facter.value(:hostname)
  return get_host_vservs(hostname)
end

