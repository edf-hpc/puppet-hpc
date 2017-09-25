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

# This module can be used to modify the parameters of journald in
# /etc/systemd/journald.conf. Since we do not want to maintain the parameters
# list with their default values in the module, it just modifies selected
# lines. The drawback is that a configuration change does not restore previous
# settings.


# @param config_manage     Let this class modify the configuration file
#          (default: true)
# @param config_options    Array of configuration options to modify
#          (default: {})
# @param service_manage    Let this class run and enable disable the
#                          service (default: true)
# @param service_ensure    Ensure state of the service: `running` or
#                          `stopped` (default: running)
# @param service_enable    Service started at boot (default: true)
# @param service_name      Name of the service
class systemd::journald (
  $config_manage  = $::systemd::journald::params::config_manage,
  $config_options = $::systemd::journald::params::config_options,
  $service_manage = $::systemd::journald::params::service_manage,
  $service_ensure = $::systemd::journald::params::service_ensure,
  $service_enable = $::systemd::journald::params::service_enable,
  $service_name   = $::systemd::journald::params::service_name,
) inherits systemd::journald::params {
  validate_bool($service_manage)
  validate_bool($service_enable)
  validate_string($service_name)
  validate_string($service_ensure)

  validate_bool($config_manage)
  if $config_manage {
    validate_hash($config_options)

    # The function hpc_hmap() is used here to transform the following hash
    # format:
    #
    #  { $param1 => $value1,
    #    $param2 => $value2, }
    #
    # into:
    #
    #  { $param1 => { value => $value1 },
    #    $param2 => { value => $value2 }, }

    $_config_options = hpc_hmap($config_options, 'value')

  }

  anchor { 'systemd::journald::begin': } ->
  class { '::systemd::journald::config': } ~>
  class { '::systemd::journald::service': } ->
  anchor { 'systemd::journald::end': }

}
