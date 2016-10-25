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

class conman (
  $packages        = $::conman::params::packages,
  $packages_ensure = $::conman::params::packages_ensure,
  $service         = $::conman::params::service,
  $service_ensure  = $::conman::params::service_ensure,
  $service_enable  = $::conman::params::service_enable,
  $logrotate       = $::conman::params::logrotate,
  $server_options  = {},
  $global_options  = {},
  $service_override = {},
) inherits conman::params {
  validate_array($packages)
  validate_bool($packages_ensure)
  validate_string($service)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_bool($logrotate)
  validate_hash($service_override)

  validate_hash($server_options)
  if $server_options['logdir'] {
    validate_absolute_path($server_options['logdir'])
  }
  if $server_options['pidfile'] {
    validate_absolute_path($server_options['pidfile'])
  }
  $_server_options = merge($::conman::params::server_options_default, $server_options)

  validate_hash($global_options)
  $_global_options = merge($::conman::params::global_options_default, $global_options)

  $_service_override = deep_merge($::conman::params::service_override_defaults, $service_override)

  anchor { 'conman::begin': } ->
  class { '::conman::install': } ->
  class { '::conman::config': } ->
  class { '::conman::service': } ->
  anchor { 'conman::end': }

}
