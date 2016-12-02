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

class complex::client (
  $install_manage      = $::complex::client::params::install_manage,
  $packages_manage     = $::complex::client::params::packages_manage,
  $packages            = $::complex::client::params::packages,
  $packages_ensure     = $::complex::client::params::packages_ensure,
  $config_manage       = $::complex::client::params::config_manage,
  $config_file         = $::complex::client::params::config_file,
  $user                = $::complex::client::params::user,
  $password,
) inherits complex::client::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($config_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $install_manage or $config_manage {
    validate_string($user)
  }

  if $config_manage {
    validate_absolute_path($config_file)
  }

  anchor { 'complex::client::begin': } ->
  class { '::complex::client::install': } ->
  class { '::complex::client::config': } ->
  anchor { 'complex::client::end': }

}
