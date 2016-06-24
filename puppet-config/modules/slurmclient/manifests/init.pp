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

class slurmclient (
  $config_manage  = $slurmclient::params::config_manage,
  $package_manage = $slurmclient::params::package_manage,
  $package_ensure = $slurmclient::params::package_ensure,
  $package_name   = $slurmclient::params::package_name,
) inherits slurmclient::params {

  validate_bool($config_manage)
  validate_bool($package_manage)
  if $package_manage {
    validate_string($package_ensure)
    validate_array($package_name)
  }

  anchor { 'slurmclient::begin': } ->
#  class { '::slurmclient::install': } ->
  class { '::slurmclient::config': } ->
  anchor { 'slurmclient::end': }
}
