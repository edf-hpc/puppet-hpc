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

# Install a Conman server and provides ressources to configure it.
#
# # Server options
#
# The parameter `server_options` hash is merged with some defaults.
#   - 'logdir'    => '/var/log/conman'
#   - 'pidfile'   => '/var/run/conmand.pid'
#   - 'syslog'    => 'local1'
#   - 'timestamp' => '5m'
#
# # Global options
#
# The parameter `global_options` hash is merged with some defaults.
#   - 'logopts'  => 'lock,sanitize,timestamp'
#   - 'log'      => '%N/console.log'
#   - 'seropts'  => '115200,8n1'
#   - 'ipmiopts' => 'U:admin,P:admin'
#
# These two hash defines the general parameters of the service and can be 
# overrided parameter by parameter.
# @param packages Package list
# @param packages_ensure Should packages be installed, latest or absent.
# @param service Service name (default: 'conman')
# @param service_ensure Should the service run or be stopped (default: running)
# @param service_enable Should the service be enabled (default: true)
# @param logrotate Should the logs be rotated (default: true)
# @param server_options Supplementary server parameters for conman service
#             (default: {})
# @param global_options Supplementary global parameters for conman service
#             (default: {})
# @param service_override Params to override systemd service parameters 
#             (default: {})
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
