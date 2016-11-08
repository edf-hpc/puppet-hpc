##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
#  Contact: CCN_HPC <dsp_cspit_ccn_hpc@edf.fr>                           #
#                                                                        #
#  This program is free software; you can redistribute in and/or         #
#  modify it under the terms of the GNU General Public License,          #
#  version 2, as published by the Free Software Foundation.              #
#  This program is distributed in the hope that it will be useful,       #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#  GNU General Public License for more details.                          #
##########################################################################

class calibreperms (
  $packages        = $::calibreperms::params::packages,
  $packages_ensure = $::calibreperms::params::packages_ensure,
  $hpc_files       = $::calibreperms::params::hpc_files,
) inherits calibreperms::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_hash($hpc_files)

  anchor { 'calibreperms::begin': } ->
  class { '::calibreperms::install': } ->
  class { '::calibreperms::config': } ->
  anchor { 'calibreperms::end': }

}
