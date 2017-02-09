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
# @param packages Array of packages to install
# @param packages_ensure Target state of the installed packages (default: latest)
# @param sources Hash with the description of sources to collect
#          periodically
# @param base_dir Absolute path of the base directory to create
class hpc_backup::switches (
  $packages        = $hpc_backup::switches::params::packages,
  $packages_ensure = $hpc_backup::switches::params::packages_ensure,
  $sources         = $hpc_backup::switches::params::sources,
  $base_dir        = $hpc_backup::switches::params::base_dir,
) inherits hpc_backup::switches::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_hash($sources)
  validate_absolute_path($base_dir)

  anchor { 'hpc_backup::switches::begin': } ->
  class { '::hpc_backup::switches::install': } ->
  class { '::hpc_backup::switches::config': } ->
  anchor { 'hpc_backup::switches::end': }

}
