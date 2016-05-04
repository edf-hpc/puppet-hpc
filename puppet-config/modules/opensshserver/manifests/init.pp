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

class opensshserver (
  $packages                  = $opensshserver::params::packages,
  $packages_ensure           = $opensshserver::params::packages_ensure,
  $main_config               = $opensshserver::params::main_config,
  $sshd_config_options       = $opensshserver::params::sshd_config_options,
  $augeas_context            = $opensshserver::params::augeas_context,
  $rootkeys_directory_source = $opensshserver::params::rootkeys_directory_source,
  $root_key_directory        = $opensshserver::params::root_key_directory,
  $decrypt_passwd            = $opensshserver::params::decrypt_passwd,
  $cluster                   = '',
) inherits opensshserver::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($main_config)
  validate_array($sshd_config_options)
  validate_absolute_path($augeas_context)
  validate_string($decrypt_passwd)

  anchor { 'opensshserver::begin': } ->
  class { '::opensshserver::install': } ->
  class { '::opensshserver::config': } ->
  class { '::opensshserver::service': } ->
  class { '::opensshserver::keys': } ->
  anchor { 'opensshserver::end': }

}
