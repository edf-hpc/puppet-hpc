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

# Adds a branch to loaded aufs
#
# @param service         Name of the service to manage (default: 'aufs')
# @param service_ensure  Target state for the service (default: 'running')
# @param service_enable  The service starts at boot time (default: true)
# @param branch_name     Name of branch to add
class aufs (
  $service         = $::aufs::params::service,
  $service_ensure  = $::aufs::params::service_ensure,
  $service_enable  = $::aufs::params::service_enable,
  $service_options = {},
) inherits aufs::params {

  validate_string($service)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_hash($service_options)

  $_service_options = deep_merge($::aufs::params::service_options_defaults, $service_options)

  anchor { 'aufs::begin': } ->
  class { '::aufs::config': } ->
  class { '::aufs::service': } ->
  anchor { 'aufs::end': }
}
