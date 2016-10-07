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

class nvidia (
  $packages             = $::nvidia::params::packages,
  $packages_ensure      = $::nvidia::params::packages_ensure,
  $modprobe_file        = $::nvidia::params::modprobe_file,
) inherits nvidia::params {
  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($modprobe_file)

  anchor { 'nvidia::begin': } ->
  class { '::nvidia::install': } ->
  class { '::nvidia::config': } ->
  anchor { 'nvidia::end': }

}
