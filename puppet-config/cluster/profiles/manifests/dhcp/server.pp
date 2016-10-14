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
# Maybe we need to merge profile::dhcp::server and profile::bootsystem::server
# to avoid this.
# * `profiles::bootsystem::boot_params`
class profiles::dhcp::server {

  ## Hiera lookups
  $default_options = hiera_array('profiles::dhcp::default_options')
  $global_options  = hiera_array('profiles::dhcp::global_options')
  $sharednet       = hiera_hash('profiles::dhcp::sharednet')
  $includes        = hiera_hash('profiles::dhcp::includes')
  $bootmenu_url    = hiera('profiles::dhcp::bootmenu_url')
  $boot_params     = hiera('profiles::bootsystem::boot_params')

  $my_address      = $::hostfile[$::hostname]
  $dhcp_config     = $::dhcpconfig

  # Pass config options as a class parameter
  class { '::iscdhcp':
    my_address      => $my_address,
    dhcp_config     => $dhcp_config,
    bootmenu_url    => $bootmenu_url,
    default_options => $default_options,
    global_options  => $global_options,
    sharednet       => $sharednet,
    includes        => $includes,
    boot_params     => $boot_params,
  }

}
