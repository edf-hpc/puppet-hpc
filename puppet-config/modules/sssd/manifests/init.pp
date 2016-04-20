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

class sssd (
  $packages            = $sssd::params::packages,
  $packages_ensure     = $sssd::params::packages_ensure,
  $config_dir          = $sssd::params::config_dir,
  $config_file         = $sssd::params::config_file,
  $config_options      = {},
  $default_file        = $sssd::params::default_file,
  $default_options     = $sssd::params::default_options,
  $cluster             = '',
) inherits sssd::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_dir)
  validate_absolute_path($config_file)
  validate_hash($config_options)
  validate_absolute_path($default_file)
  validate_hash($default_options)

  anchor { 'sssd::begin': } ->
  class { '::sssd::install': } ->
  class { '::sssd::config': } ->
  class { '::sssd::service': } ->
  anchor { 'sssd::end': }

}
