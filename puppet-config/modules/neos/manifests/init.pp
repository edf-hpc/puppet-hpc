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

class neos (
  $packages        = $::neos::params::packages,
  $packages_ensure = $::neos::params::packages_ensure,
  $config_file     = $::neos::params::config_file,
  $config_options  = {},
) inherits neos::params {
  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_hash($config_options)

  $_config_options = deep_merge($::neos::params::config_options_default, $config_options)

  anchor { 'neos::begin': } ->
  class { '::neos::install': } ->
  class { '::neos::config': } ->
  anchor { 'neos::end': }

}

Class['::neos'] -> Class ['::neos::web']
