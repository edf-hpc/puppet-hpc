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

# OpenLDAP server
#
# @param packages Array of package names to install
# @param packages_ensure Target state of the paackages (default: 'present')
# @param default_file Path of the default parameters file (default or sysconfig)
# @param default_options Content of the ``default_file``
# @param service_override Hash of the content of the systemd unit override
#          file.
class openldap (
  $packages                   = $openldap::params::packages,
  $packages_ensure            = $openldap::params::packages_ensure,
  $default_file               = $openldap::params::default_file,
  $default_options            = {},
  $service_override           = {},
) inherits openldap::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($default_file)
  validate_hash($default_options)
  validate_hash($service_override)

  $_default_options = deep_merge($openldap::params::default_options_defaults, $default_options)

  $_service_override = deep_merge($::openldap::params::service_override_defaults, $service_override)

  anchor { 'openldap::begin': } ->
  class { '::openldap::install': } ->
  class { '::openldap::config': } ->
  class { '::openldap::service': } ->
  anchor { 'openldap::end': }

}
