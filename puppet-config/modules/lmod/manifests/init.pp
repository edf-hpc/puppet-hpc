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

class lmod (
  $packages        = $lmod::params::packages,
  $packages_ensure = $lmod::params::packages_ensure,
  $config_file     = $lmod::params::config_file,
  $config_options  = $lmod::params::config_options,
  $rootdirmodules  = $lmod::params::rootdirmodules,
) inherits lmod::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_array($config_options)
  validate_absolute_path($rootdirmodules)

  anchor { 'lmod::begin': } ->
  class { '::lmod::install': } ->
  class { '::lmod::config': } ->
  anchor { 'lmod::end': }

}
