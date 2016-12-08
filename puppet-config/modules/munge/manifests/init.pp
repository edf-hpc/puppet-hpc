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

# Install munge and setup a munge key
#
# @param packages     Package list
# @param packages_ensure  Should packages be installed, latest or absent.
# @param packages_manage  If install package or not (Debian and RedHat default: true, other: false)
# @param service     Service name (default: munge)
# @param service_ensure   Should the service run or be stopped (default: running)
# @param service_enable   Should the service be enabled (default: true)
# @param service_manage   Determine if service part must be managed or ignored by puppet (default: true)
# @param auth_key_path    Key path (default: /etc/munge)
# @param auth_key_mode    Mode on key file (default: 0400)
# @param auth_key_name    Absolute path of key (default: `auth_key_path`/munge.key)
# @param auth_key_owner   Owner of key (default: munge)
# @param auth_key_source  Encrypted source key (default: munge/munge.key.enc)
# @param decrypt_password Password to use to decrypt `auth_key_source`

class munge (
  $service           = $munge::params::service,
  $service_enable    = $munge::params::service_enable,
  $service_ensure    = $munge::params::service_ensure,
  $service_manage    = $munge::params::service_manage,
  $auth_key_path     = $munge::params::auth_key_path,
  $auth_key_mode     = $munge::params::auth_key_mode,
  $auth_key_name     = $munge::params::auth_key_name,
  $auth_key_owner    = $munge::params::auth_key_owner,
  $auth_key_source   = $munge::params::auth_key_source,
  $decrypt_passwd    = $munge::params::decrypt_passwd,
  $packages_ensure   = $munge::params::packages_ensure,
  $packages_manage   = $munge::params::packages_manage,
  $packages          = $munge::params::packages,
) inherits munge::params {


  ### Validate params ###
  validate_string($service)
  validate_bool($service_enable)
  validate_string($service_ensure)
  validate_bool($service_manage)
  validate_numeric($auth_key_mode)
  validate_absolute_path($auth_key_path)
  validate_absolute_path($auth_key_name)
  validate_string($auth_key_owner)
  validate_string($auth_key_source)
  validate_string($packages_ensure)
  validate_bool($packages_manage)
  if $packages_manage { validate_array($packages)}

  anchor { 'munge::begin': } ->
  class { '::munge::install': } ->
  class { '::munge::config': } ->
  class { '::munge::service': } ->
  anchor { 'munge::end': }
}
