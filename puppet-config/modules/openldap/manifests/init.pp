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

class openldap (
  $packages                   = $openldap::params::packages,
  $packages_ensure            = $openldap::params::packages_ensure,
  $default_file               = $openldap::params::default_file,
  $default_options            = $openldap::params::default_options,
  $decrypt_passwd             = $openldap::params::decrypt_passwd,
  $cluster                    = '',
) inherits openldap::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($default_file)
  validate_hash($default_options)

  anchor { 'openldap::begin': } ->
  class { '::openldap::install': } ->
  class { '::openldap::config': } ->
  class { '::openldap::service': } ->
  anchor { 'openldap::end': }

}
