##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2017 EDF S.A.                                      #
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


# Create a conman server with the hpc default config
#
# If `$vip_name` is provided, the service is not started
# automatically by systemd. It will be started by a script
# for a `hpc_ha::vip`.
#
# @param vip_name    String representing the name of `Hpc_ha::Vip` resource
# @param roles       Array of roles to define console for
# @param device_type Device type (`ipmi` or `telnet`)
# @param prefix      Hostname prefix (default depends on the `$device_type`)
# @param port        Port (default depends on the `$device_type)
class hpc_conman::server (
  $vip_name      = $::hpc_conman::server::params::vip_name,
  $roles         = $::hpc_conman::server::params::roles,
  $device_type   = $::hpc_conman::server::params::device_type,
  $prefix        = undef,
  $port          = undef
) inherits hpc_conman::server::params {


  if $vip_name {
    #Service start is controlled by the HA script to follow
    #the VIP
    $service_ensure = undef
    $service_enable = false

    hpc_ha::vip_notify_script { 'conman':
      ensure   => present,
      vip_name => $vip_name,
      source   => 'puppet:///modules/hpc_conman/conman_ha_notify.sh'
    }
  } else {
    $service_ensure = 'running'
    $service_enable = true

  }

  class { 'conman':
    service_ensure => $service_ensure,
    service_enable => $service_enable,
  }

  if $prefix {
    $_prefix = $prefix
  } else {
    $_prefix = $::hpc_conman::server::params::prefix_default[$device_type]
  }

  if $port {
    $_port = $port
  } else {
    $_port = $::hpc_conman::server::params::port_default[$device_type]
  }

  hpc_conman::server::role_consoles{ $roles:
    type           => $device_type,
    console_prefix => $_prefix,
    console_port   => $_port
  }
}
