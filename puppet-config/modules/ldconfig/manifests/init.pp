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

# Manage supplementary ldconfig
#
# @param service_manage  Public class manages the service state (default: true)
# @param service_name    Name of the service to manage (default:
#                        'simple-service')
# @param service_ensure  Target state for the service (default: 'running')
# @param service_enable  The service starts at boot time (default: true)
# @param service_definition Content of the unit file (default: minimal service)
# @param service_triggers Array with a list of units that trigger the service
#          when they are activated (default []).
# @param ldconfig_directories Array of directories that should be added to the
#          system ldconfig (default: [])
class ldconfig (
  $service_manage       = $::ldconfig::params::service_manage,
  $service_name         = $::ldconfig::params::service_name,
  $service_ensure       = $::ldconfig::params::service_ensure,
  $service_enable       = $::ldconfig::params::service_enable,
  $service_definition   = $::ldconfig::params::service_definition,
  $service_triggers     = $::ldconfig::params::service_triggers,
  $ldconfig_directories = $::ldconfig::params::ldconfig_directories,
) inherits ldconfig::params {

  if $service_manage {
    validate_string($service_name)
    validate_string($service_ensure)
    validate_bool($service_enable)
    validate_hash($service_definition)
    validate_array($service_triggers)
  }
  validate_array($ldconfig_directories)

  anchor { 'ldconfig::begin': } ->
  class { '::ldconfig::config': } ->
  class { '::ldconfig::service': } ->
  anchor { 'ldconfig::end': }

}
