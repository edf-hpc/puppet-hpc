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

class openmpi (
  $mca_main_file    = $::openmpi::params::mca_main_file,
  $mca_main_options = $::openmpi::params::mca_main_options,
  $mca_param_files  = $::openmpi::params::mca_param_files,
) inherits openmpi::params {

  validate_absolute_path($mca_main_file)
  validate_hash($mca_main_options)
  validate_hash($mca_param_files)

  anchor { 'openmpi::begin':} ->
  class { '::openmpi::config': } ->
  anchor { 'openmpi::end': }

}
