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

class carboncrelay (
  $service          = $::carboncrelay::params::service,
  $service_ensure   = $::carboncrelay::params::service_ensure,
  $service_enable   = $::carboncrelay::params::service_enable,
  $packages         = $::carboncrelay::params::packages,
  $packages_ensure  = $::carboncrelay::params::packages_ensure,
  $config_file      = $::carboncrelay::params::config_file,
  $service_override = {},
) inherits carboncrelay::params {
  validate_string($service)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_hash($service_override)

  $_service_override = deep_merge($::carboncrelay::params::service_override_defaults, $service_override)

  anchor { 'carboncrelay::begin': } ->
  class { '::carboncrelay::install': } ->
  class { '::carboncrelay::config': } ->
  class { '::carboncrelay::service': } ->
  anchor { 'carboncrelay::end': }

}
