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

class complex::server (
  $install_manage      = $::complex::server::params::install_manage,
  $packages_manage     = $::complex::server::params::packages_manage,
  $packages            = $::complex::server::params::packages,
  $packages_ensure     = $::complex::server::params::packages_ensure,
  $services_manage     = $::complex::server::params::services_manage,
  $services            = $::complex::server::params::services,
  $services_ensure     = $::complex::server::params::services_ensure,
  $services_enable     = $::complex::server::params::services_enable,
  $config_manage       = $::complex::server::params::config_manage,
  $config_file         = $::complex::server::params::config_file,
  $config_options      = {},
  $user                = $::complex::server::params::user,
  $password,
) inherits complex::server::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($services_manage)
  validate_bool($config_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $services_manage {
    validate_array($services)
    validate_string($services_ensure)
    validate_bool($services_enable)
  }

  if $install_manage or $config_manage {
    validate_string($user)
  }

  if $config_manage {
    validate_absolute_path($config_file)
    validate_hash($config_options)
    validate_string($password)
    $_config_options = deep_merge(
      $config_options,
      $::complex::server::params::config_options)
  }

  anchor { 'complex::server::begin': } ->
  class { '::complex::server::install': } ->
  class { '::complex::server::config': } ->
  class { '::complex::server::service': } ->
  anchor { 'complex::server::end': }
 
  # config change must notify service 
  Class['::complex::server::config'] ~> Class['::complex::server::service']

}
