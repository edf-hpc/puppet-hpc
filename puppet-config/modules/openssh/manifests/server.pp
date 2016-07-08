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

# Setup the OpenSSH server on the nodes with root keys
#
# The module provides a default public root key that match the one setup
# by default in `openssh::client`, this should never be used in
# production. You must override it with the `root_public_key` parameter.
#
# Note this is the actual key without the `ssh-rsa` and user name, not a
# file path.
#
# @param packages_ensure   Install mode (`latest` or `present`) for the
#                          packages (default: `present`)
# @param packages          Array of packages names
# @param service_ensure    Ensure state of the service: `running` or
#                          `stopped` (default: running)
# @param service_enable    Service started at boot (default: true)
# @param service           Name of the service
# @param cluster           Name of the cluster for comment (default: 'cluster')
# @param root_public_key   String of the RSA public key
class openssh::server (
  $packages                 = $::openssh::server::params::packages,
  $packages_ensure          = $::openssh::server::params::packages_ensure,
  $config_file              = $::openssh::server::params::config_file,
  $config_augeas            = $::openssh::server::params::config_augeas,
  $augeas_context           = $::openssh::server::params::augeas_context,
  $service                  = $::openssh::server::params::service,
  $service_enable           = $::openssh::server::params::service_enable,
  $service_ensure           = $::openssh::server::params::service_ensure,
  $cluster                  = $::openssh::server::params::cluster,
  $root_public_key          = $::openssh::server::params::root_public_key,
  $host_private_key_rsa     = $::openssh::server::params::host_private_key_rsa,
  $host_public_key_rsa      = $::openssh::server::params::host_public_key_rsa,
  $host_private_key_dsa     = $::openssh::server::params::host_private_key_dsa,
  $host_public_key_dsa      = $::openssh::server::params::host_public_key_dsa,
  $host_private_key_ecdsa   = $::openssh::server::params::host_private_key_ecdsa,
  $host_public_key_ecdsa    = $::openssh::server::params::host_public_key_ecdsa,
  $host_private_key_ed25519 = $::openssh::server::params::host_private_key_ed25519,
  $host_public_key_ed25519  = $::openssh::server::params::host_public_key_ed25519,
  $hostkeys_dir             = $::openssh::server::params::hostkeys_dir,
  $hostkeys_source_dir      = $::openssh::server::params::hostkeys_source_dir,
  $decrypt_passwd           = $::openssh::server::params::decrypt_passwd,
) inherits openssh::server::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_array($config_augeas)
  validate_absolute_path($augeas_context)
  validate_string($root_public_key)

  validate_string($host_private_key_rsa)
  validate_string($host_public_key_rsa)
  validate_string($host_private_key_dsa)
  validate_string($host_public_key_dsa)
  validate_string($host_private_key_ecdsa)
  validate_string($host_public_key_ecdsa)
  validate_string($host_private_key_ed25519)
  validate_string($host_public_key_ed25519)
  validate_absolute_path($hostkeys_dir)
  validate_absolute_path($hostkeys_source_dir)

  anchor { 'openssh::server::begin': } ->
  class { '::openssh::server::install': } ->
  class { '::openssh::server::config': } ->
  class { '::openssh::server::keys': } ~>
  class { '::openssh::server::service': } ->
  anchor { 'openssh::server::end': }

}
