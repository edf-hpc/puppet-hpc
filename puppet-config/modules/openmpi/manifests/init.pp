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

class openmpi (
  $device_config  = $openmpi::params::device_config,
  $default_config = $openmpi::params::default_config,
) inherits openmpi::params {

  validate_hash($device_config)
  validate_hash($default_config)

  anchor { 'openmpi::begin':} ->
  class { '::openmpi::config': } ->
  anchor { 'openmpi::end': }

}
