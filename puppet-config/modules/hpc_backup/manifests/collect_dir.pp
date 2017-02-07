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

# Configures crons to collect remote directories
#
# @param sources Hash with the description of sources to collect
#          periodically
# @param base_dir Absolute path of the base directory to create
class hpc_backup::collect_dir (
  $sources  = $hpc_backup::collect_dir::params::sources,
  $base_dir = $hpc_backup::collect_dir::params::base_dir,
) inherits hpc_backup::collect_dir::params {

  validate_hash($sources)
  validate_absolute_path($base_dir)

  anchor { 'hpc_backup::collect_dir::begin': } ->
  class { '::hpc_backup::collect_dir::config': } ->
  anchor { 'hpc_backup::collect_dir::end': }

}
