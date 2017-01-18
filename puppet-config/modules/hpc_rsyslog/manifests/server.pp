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

# Deploys resources complementary to saz-rsyslog community module on rsyslog
# servers.
#
# @param config_manage    Public class manages the configuration (default: true)
# @param service_name     Name of the service to manage (default:
#                         'rsyslog')
# @param logrotate_rules  Hash of logrotate rules definitions to deploy (default:
#                         {})
# @param service_override Hash of the content of the systemd unit override
#                         file (default: {}).
class hpc_rsyslog::server (
  $config_manage    = $::hpc_rsyslog::server::params::config_manage,
  $service_name     = $::hpc_rsyslog::server::params::service_name,
  $logrotate_rules  = {},
  $service_override = {},
) inherits hpc_rsyslog::server::params {

  validate_bool($config_manage)

  if $config_manage {
    validate_string($service_name)
    validate_hash($logrotate_rules)
    validate_hash($service_override)

    $_logrotate_rules = deep_merge(
      $::hpc_rsyslog::server::params::logrotate_rules_defaults,
      $logrotate_rules)

    $_service_override = deep_merge(
      $::hpc_rsyslog::server::params::service_override_defaults,
      $service_override)
  }

  anchor { 'hpc_rsyslog::server::begin': } ->
  class { '::hpc_rsyslog::server::config': } ->
  anchor { 'hpc_rsyslog::server::end': }

}
