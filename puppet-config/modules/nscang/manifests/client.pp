##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

class nscang::client (
  $install_manage      = $::nscang::client::params::install_manage,
  $packages_manage     = $::nscang::client::params::packages_manage,
  $packages            = $::nscang::client::params::packages,
  $packages_ensure     = $::nscang::client::params::packages_ensure,
  $config_manage       = $::nscang::client::params::config_manage,
  $config_file         = $::nscang::client::params::config_file,
  $user                = $::nscang::client::params::user,
  $server              = $::nscang::client::params::server,
  $identity            = $::nscang::client::params::identity,
  $password,
) inherits nscang::client::params {

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
    validate_string($server)
    validate_string($identity)
    validate_string($password)
  }

  anchor { 'nscang::client::begin': } ->
  class { '::nscang::client::install': } ->
  class { '::nscang::client::config': } ->
  anchor { 'nscang::client::end': }

}
