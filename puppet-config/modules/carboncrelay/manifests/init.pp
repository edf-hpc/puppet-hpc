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

# Installs and configure carbon-c-relay
#
# @param service Service name
# @param service_ensure Target state of the service (default: 'running')
# @param service_enable Boolean: is service started at boot (default: true)
# @param packages Array of packages names
# @param packages_ensure Target state of the packages (default: 'installed')
# @param config_file Absolute path of the configuration file (default:
#          '/etc/carbon-c-relay.conf')
# @param service_override Hash of options to include in the systemd service
#          override files
# @param listen_address IP Address the carbon-c-relay should listen on,
#          all if undef (default: undef)
# @param default_file Path of the default environment file (default:
#          '/etc/default/carbon-c-relay')
# @param default_options Array with default environment file content, merged
#          with the defaults.
class carboncrelay (
  $service          = $::carboncrelay::params::service,
  $service_ensure   = $::carboncrelay::params::service_ensure,
  $service_enable   = $::carboncrelay::params::service_enable,
  $packages         = $::carboncrelay::params::packages,
  $packages_ensure  = $::carboncrelay::params::packages_ensure,
  $config_file      = $::carboncrelay::params::config_file,
  $service_override = {},
  $listen_address   = $::carboncrelay::params::listen_address,
  $default_file     = $::carboncrelay::params::default_file,
  $default_options  = {},
) inherits carboncrelay::params {
  validate_string($service)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_hash($service_override)
  validate_absolute_path($default_file)
  validate_hash($default_options)

  $_service_override = deep_merge($::carboncrelay::params::service_override_defaults, $service_override)

  if $listen_address {
    validate_string($listen_address)
    $interface_option = "-i ${listen_address}"
  } else {
    $interface_options = ''
  }
  $default_options_generated = {
    'DAEMON_ARGS' => "' -f ${config_file} ${interface_option}'"
  }
  $_default_options = deep_merge($default_options_generated, $default_options)

  anchor { 'carboncrelay::begin': } ->
  class { '::carboncrelay::install': } ->
  class { '::carboncrelay::config': } ->
  class { '::carboncrelay::service': } ->
  anchor { 'carboncrelay::end': }

}
