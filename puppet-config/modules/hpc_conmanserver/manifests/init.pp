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

class hpc_conmanserver (
  $vip_name      = $::hpc_conmanserver::params::vip_name,
  $roles         = $::hpc_conmanserver::params::roles,
  $device_type   = $::hpc_conmanserver::params::device_type,
  $prefix        = undef,
  $port          = undef
) inherits hpc_conmanserver::params {
  class { 'conman':
    serv_ensure => stopped,
    serv_enable => false,
  }

  hpc_ha::vip_notify_script { 'conman':
    ensure   => present,
    vip_name => $vip_name,
    source   => 'puppet:///modules/hpc_conmanserver/conman_ha_notify.sh'
  }

  if $prefix {
    $_prefix = $prefix
  } else {
    $_prefix = $::hpc_conmanserver::params::prefix_default[$device_type]
  }

  if $port {
    $_port = $port
  } else {
    $_port = $::hpc_conmanserver::params::port_default[$device_type]
  }

  hpc_conmanserver::role_consoles{ $roles:
    type   => $device_type, 
    console_prefix => $_prefix,
    console_port   => $_port
  }
}
