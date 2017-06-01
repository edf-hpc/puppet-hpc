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

# Setup hpcconfig apply script
# @param packages Array of packages to install
# @param packages_ensure Target state of the installed packages (default: present)
# @param config_file Path of the configuration file for hpc-config-apply
#                   (default: '/etc/hpc-config.conf')
# @param config_options Hash with the content of `config_file` (merged with defaults)
# @param service_manage If true, handle boot service state (default: true)
# @param service_name Service name
# @param service_ensure Target state of the service (default: undef)
# @param service_enable Boolean: is the service starting at boot (default:
#          true)

class hpcconfig::apply (
  $packages         = $::hpcconfig::apply::params::packages,
  $packages_ensure  = $::hpcconfig::apply::params::packages_ensure,
  $config_file      = $::hpcconfig::apply::params::config_file,
  $config_options   = {},
  $service_manage   = $::hpcconfig::apply::params::service_manage,
  $service_name     = $::hpcconfig::apply::params::service_name,
  $service_ensure   = $::hpcconfig::apply::params::service_ensure,
  $service_enable   = $::hpcconfig::apply::params::service_enable,
) inherits hpcconfig::apply::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_hash($config_options)
  validate_bool($service_manage)
  validate_string($service_name)
  if $service_ensure {
    validate_string($service_ensure)
  }
  validate_bool($service_enable)

  $_config_options = deep_merge($::hpcconfig::apply::params::config_options_defaults, $config_options)

  anchor { 'hpcconfig::apply::begin': } ->
  class { '::hpcconfig::apply::install': } ->
  class { '::hpcconfig::apply::config': } ->
  class { '::hpcconfig::apply::service': } ->
  anchor { 'hpcconfig::apply::end': }

}
