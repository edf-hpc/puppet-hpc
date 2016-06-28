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

# Setup a DHCP server for the cluster
#
# ## Hiera 
# * `cluster_prefix`
# * `profiles::dhcp::bootmenu_url`
# * `profiles::dhcp::ipxebin`
# * `profiles::dhcp::failover` (`hiera_hash`)
# * `profiles::dhcp::sharednet` (`hiera_hash`)
# * `profiles::dhcp::includes` (`hiera_hash`)
# * `profiles::dhcp::default_options` (`hiera_array`)
# * `profiles::dhcp::global_options` (`hiera_array`)
class profiles::dhcp::server {

  ## Hiera lookups
  $default_options = hiera_array('profiles::dhcp::default_options')
  $global_options  = hiera_array('profiles::dhcp::global_options')
  $failover        = hiera_hash('profiles::dhcp::failover')
  $sharednet       = hiera_hash('profiles::dhcp::sharednet')
  $includes        = hiera_hash('profiles::dhcp::includes')
  $bootmenu_url    = hiera('profiles::dhcp::bootmenu_url')
  $ipxebin         = hiera('profiles::dhcp::ipxebin')

  $my_address      = $::hostfile[$::hostname]
  $dhcp_config     = $::dhcpconfig
  $prefix          = hiera('cluster_prefix')
  
  # Primary server has an index of 1
  # Secondary server has an index of 2 
  if $::puppet_index == '1' {
    $peer_address  = $::hostfile["${prefix}${::puppet_role}2"]
    $failover_add = {
      role            => 'primary',
      load_split      => '128',
    }
  } else {
    $peer_address  = $::hostfile["${prefix}${::puppet_role}1"]
    $failover_add = {
      role            => 'secondary',
      load_split      => '',
    }
  }
  $_failover = merge($failover, $failover_add)
  $virtual_address = $::hostfile["${prefix}${::puppet_role}"]

  # Pass config options as a class parameter
  class { '::iscdhcp':
    my_address      => $my_address,
    peer_address    => $peer_address,
    virtual_address => $virtual_address,
    dhcp_config     => $dhcp_config,
    bootmenu_url    => $bootmenu_url,
    ipxebin         => $ipxebin,
    default_options => $default_options,
    global_options  => $global_options,
    failover        => $_failover,
    sharednet       => $sharednet,
    includes        => $includes,
  }

}
