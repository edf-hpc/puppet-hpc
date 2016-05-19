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

class shorewall (
  $service          = $::shorewall::params::service,
  $service_ensure   = $::shorewall::params::service_ensure,
  $service_enable   = $::shorewall::params::service_enable,
  $packages         = $::shorewall::params::packages,
  $packages_ensure  = $::shorewall::params::packages_ensure,
  $ip_forwarding    = $::shorewall::params::ip_forwarding,
  $config_dir       = $::shorewall::params::config_dir,
  $config_file      = $::shorewall::params::config_file,
  $interfaces_file  = $::shorewall::params::interfaces_file,
  $zones_file       = $::shorewall::params::zones_file,
  $masq_file        = $::shorewall::params::masq_file,
  $policy_file      = $::shorewall::params::policy_file,
  $rules_file       = $::shorewall::params::rules_file,
  $default_file     = $::shorewall::params::default_file,
) inherits shorewall::params {
  validate_string($service)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_dir)
  validate_absolute_path($config_file)
  validate_absolute_path($interfaces_file)
  validate_absolute_path($zones_file)
  validate_absolute_path($masq_file)
  validate_absolute_path($policy_file)
  validate_absolute_path($rules_file)
  validate_absolute_path($default_file)

  anchor { 'shorewall::begin': } ->
  class { '::shorewall::install': } ->
  class { '::shorewall::config': } ->
  class { '::shorewall::service': } ->
  anchor { 'shorewall::end': }

}
