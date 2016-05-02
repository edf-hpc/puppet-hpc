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
  $vip_name   = $::hpc_conmanserver::params::vip_name,
  $roles      = $::hpc_conmanserver::params::roles,
  $bmc_prefix = $::hpc_conmanserver::params::bmc_prefix,
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

  hpc_conmanserver::role_consoles{ $roles:
    bmc_prefix => $bmc_prefix,
  }
}
