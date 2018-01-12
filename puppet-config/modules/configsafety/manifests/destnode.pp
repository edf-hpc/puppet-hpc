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

class configsafety::destnode (
  $configsafety_backup_destination  = $configsafety::params::configsafety_backup_destination,
  $configsafety_ssh_source    = '',
  $configsafety_ssh_user    = '',
  $configsafety_ssh_key      = '',
  $configsafety_ssh_type    = '',
) inherits configsafety::params {

  validate_string($configsafety_ssh_source)
  validate_string($configsafety_ssh_user)
  validate_string($configsafety_ssh_key)
  validate_string($configsafety_ssh_type)

  ssh_authorized_key { "$configsafety_ssh_source":
  ensure => present,
  user   => "$configsafety_ssh_user",
  key    => "$configsafety_ssh_key",
  type   => "$configsafety_ssh_type",
  }

}
