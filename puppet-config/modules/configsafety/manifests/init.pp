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

class configsafety (
  $configsafety_config_files		= $configsafety::params::configsafety_config_files,
  $configsafety_exclude_files_rsync	= $configsafety::params::configsafety_exclude_files_rsync,
  $configsafety_path_incl_dar		= $configsafety::params::configsafety_path_incl_dar,
  $packages         			= $configsafety::params::packages,
  $packages_ensure  			= $configsafety::params::packages_ensure,
  $config_options   			= {},
  $config_excl_files_rsync		= [],
  $config_path_incl_dar                 = [],
  $crontab_entries                      = {},
  $node_cfg				= '',
) inherits configsafety::params {

  validate_absolute_path($configsafety_config_files)
  validate_absolute_path($configsafety_exclude_files_rsync)
  validate_absolute_path($configsafety_path_incl_dar)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_hash($config_options)
  validate_string($node_cfg)
  validate_hash($crontab_entries)

  $_config_options=deep_merge($configsafety::params::config_options_defaults, $config_options)

  anchor { 'configsafety::begin': } ->
  class { '::configsafety::install': } ->
  class { '::configsafety::config': } ->
  anchor { 'configsafety::end': }

}
