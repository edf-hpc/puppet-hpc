##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014_2016 EDF S.A.                                      #
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

class environment_modules (
  $packages        = $environment_modules::params::packages,
  $packages_ensure = $environment_modules::params::packages_ensure,
  $config_file     = $environment_modules::params::config_file,
  $config_options  = $environment_modules::params::config_options,
  $rootdirmodules  = $environment_modules::params::rootdirmodules,
) inherits environment_modules::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_array($config_options)
  validate_absolute_path($rootdirmodules)

  anchor { 'environment_modules::begin': } ->
  class { '::environment_modules::install': } ->
  class { '::environment_modules::config': } ->
  anchor { 'environment_modules::end': }

}
