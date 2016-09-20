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
require 'facter/application'

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

def get_cluster_prefix()
  key = 'cluster_prefix'
  prefix = $hiera.lookup(key,
                         $options[:default],
                         $options[:scope],
                         nil,
                         $options[:resolution_type])
  return prefix
end

# To avoid many many hiera lookups, we get cluster prefix only once in this
# global variable. Then functions that need to know the cluster prefix simply
# refer to this variable.
$CLUSTER_PREFIX = get_cluster_prefix()

def get_role_by_hostname(hostname)
  if hostname =~ /^#{$CLUSTER_PREFIX}([a-z]+)[0-9]+$/
    return $1
  else
    return 'default'
  end
end

def roles()
  # FIXME: ruby functions should not depend on facts
  hostlist = Facter.value('hostfile')
  roles = Array.new
  hostlist.each do |host|
    hostname = host[0]
    role = get_role_by_hostname(hostname)
    # ignore the default role
    if role != 'default'
      roles.push(role) unless roles.include?(role)
    end
  end
  return roles
end

def get_profiles_by_role(role)
  key = 'profiles'
  # clone the default cope from $options and add the role in parameter
  scope = $options[:scope].clone
  scope['puppet_role'] = role
  puts("lookup with scope #{scope}")
  profiles = $hiera.lookup(key,
                           $options[:default],
                           scope,
                           nil,
                           $options[:resolution_type])
  return profiles
end

def get_hosts_by_role(role)
  # FIXME: ruby functions should not depend on facts
  hostlist = Facter.value('hostfile')
  hosts = Array.new
  hostlist.each do |host|
    hostname = host[0]
    hosts.push(hostname) if get_role_by_hostname(hostname) == role
  end
  return hosts 
end

def get_hosts_by_profile(profile)
  # To get the list of hosts having a particular profile, the function iterates
  # over the list of roles. For each role, it checks if the role includes the
  # given profile. If yes, the hosts of the role are appending to the resuling
  # array.
  hosts = Array.new
  roles = roles()
  puts("lists of roles: #{roles}")
  full_profile_name = 'profiles::' + profile
  roles.each do |role|
    profiles = get_profiles_by_role(role)
    puts("profiles for role #{role}: #{profiles}")
    if not profiles.nil? and profiles.include?(full_profile_name)
      hosts += get_hosts_by_role(role)
    end
  end
  # remove duplicates in the resulting array
  return hosts.uniq
end
