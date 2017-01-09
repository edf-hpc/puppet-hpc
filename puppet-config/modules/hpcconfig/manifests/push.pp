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

# Setup hpcconfig push script
# @param packages Array of packages to install
# @param packages_ensure Target state of the installed packages (default: present)
# @param config_file Path of the configuration file for hpc-config-push
#                   (default: '/etc/hpc-config.conf')
# @param config_options Hash with the content of `config_file` (merged with defaults)
# @param eyaml_file Path of the configuration file for eyaml command
#                   (default: '/root/.eyaml/config.yaml')
# @param eyaml_config_options Hash with the content of `eyaml_file`

class hpcconfig::push (
  $packages             = $::hpcconfig::push::params::packages,
  $packages_ensure      = $::hpcconfig::push::params::packages_ensure,
  $config_file          = $::hpcconfig::push::params::config_file,
  $eyaml_file           = $::hpcconfig::push::params::eyaml_file,
  $eyaml_config_options = $::hpcconfig::push::params::eyaml_config_options,
  $config_options   = {},
) inherits hpcconfig::push::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_hash($config_options)
  validate_absolute_path($eyaml_config_file)
  validate_hash($eyaml_config_options)

  $_config_options=deep_merge($::hpcconfig::push::params::config_options_defaults, $config_options)

  anchor { 'hpcconfig::push::begin': } ->
  class { '::hpcconfig::push::install': } ->
  class { '::hpcconfig::push::config': } ->
  anchor { 'hpcconfig::push::end': }

}
