##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2016 EDF S.A.                                      #
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

define hpc_ha::vip (
  $net_id,
  $ip_address,
  $router_id,
  $auth_secret,
  $prefix = '',
  $notify_script = undef,
) {

  validate_string($net_id)
  validate_string($prefix)
  validate_ip_address($ip_address)
  validate_integer($router_id)
  validate_string($auth_secret)

  if ! $::mynet_topology[$net_id] {
    $mynet_names = keys($::mynet_topology)
    fail("${net_id} is not in the node networks topology (valid networks: ${mynet_names})")
  }

  $interface = $::mynet_topology[$net_id]['interfaces'][0]
  validate_string($interface)

  # Create the vrrp_instance ID
  $up_name = upcase($name)
  $up_prefix = upcase($prefix)
  $vrrp_instance_id = "VI_${up_prefix}${up_name}"

  # Setup the notify script and run-parts dirs
  if $notify_script {
    $_notify_script = $notify_script
  } else {
    $_notify_script = $::hpc_ha::default_notify_script
  }

  $scripts_dir = "/etc/hpc_ha/${vrrp_instance_id}"
  $notify_dirs = [
    $scripts_dir,
    "${scripts_dir}/notify",
    "${scripts_dir}/notify_master",
    "${scripts_dir}/notify_backup",
    "${scripts_dir}/notify_fault",
    "${scripts_dir}/notify_stop",
  ]

  file { $notify_dirs:
    ensure => directory,
  }

  # Create the instance itself
  ::keepalived::vrrp::instance { $vrrp_instance_id:
    interface         => $interface,
    state             => 'BACKUP',
    virtual_router_id => $router_id,
    priority          => '100',
    auth_type         => 'PASS',
    auth_pass         => $auth_secret,
    virtual_ipaddress => [ $ip_address ],
    notify_script     => $_notify_script,
  }

  # disable martian logging since normal with VLAN with multiple IP networks
  $sysctl_file    = "hatuning_${name}.conf"
  $sysctl_options = {
    'net.ipv4.conf.all.log_martians'                                         => '0',
    "net.ipv4.conf.${::mynet_topology[$net_id][interfaces][0]}.arp_ignore"   => '1',
    "net.ipv4.conf.${::mynet_topology[$net_id][interfaces][0]}.arp_announce" => '2',
  }
  hpclib::sysctl { $sysctl_file :
    config      => $sysctl_options,
    sysctl_file => $sysctl_file,
  }

}
