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

# Configure a Virtual IP address configured with VRRP
#
# This resource relies on keepalived.
#
# @param net_id Network ID (wan, administration...) of the network where
#         this VIP will be.
# @param ip_address IPv4 address of VIP
# @param router_id Unique integer for this VIP, it should be unique on the
#         the L2 segment. Cluster sharing an external network should not
#         use the same ids.
# @param auth_secret Secret shared between the routers to authenticate the
#         origin.
# @param master Is this node the master for this vip
# @param prority Integer giving the priority of this node for this vip
# @param prefix Prefix for the name of the instance
# @param notify_script Configure a notify script (default: false)
# @param advert_int Interval between advertisement (heartbeat) (default:
#         1s)
define hpc_ha::vip (
  $net_id,
  $ip_address,
  $router_id,
  $auth_secret,
  $master,
  $priority,
  $prefix = '',
  $notify_script = false,
  $advert_int = undef,
) {

  validate_string($net_id)
  validate_string($prefix)
  validate_ip_address($ip_address)
  validate_integer($router_id)
  validate_string($auth_secret)

  if $advert_int {
    validate_integer($advert_int)
  }

  if ! $::mynet_topology[$net_id] {
    $mynet_names = keys($::mynet_topology)
    fail("${net_id} is not in the node networks topology (valid networks: ${mynet_names})")
  }

  $interface = $::mynet_topology[$net_id]['interfaces'][0]
  validate_string($interface)

  # Create the vrrp_instance ID
  $_name = regsubst($name, '[:\/\n]', '')
  $up_name = upcase($name)
  $up_prefix = upcase($prefix)
  $vrrp_instance_id = "VI_${up_prefix}${up_name}"

  # Setup the notify script and run-parts dirs
  if $notify_script {
    $_notify_script = "/etc/hpc_ha/${vrrp_instance_id}/notify/vserv_${_name}_notify"
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

  if $master == true {
    $state = 'MASTER'
  } else {
    $state = 'BACKUP'
  }

  # Create the instance itself
  ::keepalived::vrrp::instance { $vrrp_instance_id:
    interface         => $interface,
    state             => $state,
    virtual_router_id => $router_id,
    priority          => $priority,
    auth_type         => 'PASS',
    auth_pass         => $auth_secret,
    virtual_ipaddress => [ $ip_address ],
    notify_script     => $_notify_script,
    advert_int        => $advert_int,
    lvs_interface     => $interface,
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
