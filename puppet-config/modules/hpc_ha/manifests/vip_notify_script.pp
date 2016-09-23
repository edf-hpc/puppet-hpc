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

define hpc_ha::vip_notify_script (
  $vip_name,
  $ensure  = present,
  $source  = undef,
) {
  validate_string($vip_name)

  $_name = regsubst($name, '[:\/\n]', '')

  $prefix = getparam(Hpc_ha::Vip[$vip_name], 'prefix')
  $up_name = upcase($vip_name)
  $up_prefix = upcase($prefix)
  $vrrp_instance_id = "VI_${up_prefix}${up_name}"
  file { "/etc/hpc_ha/${vrrp_instance_id}/notify/vserv_${_name}_notify":
    ensure  => $ensure,
    content => hpc_source_file($source),
    mode    => '0700',
    require => Hpc_ha::Vip[$vip_name],
  }

}
