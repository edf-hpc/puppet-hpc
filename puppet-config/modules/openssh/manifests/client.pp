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

# Setup the OpenSSH client and private root key
#
# @param root_key_enc   Source of the encrypted root private key file
# @param root_key_file  Destination path of the root private key file
# @param decrypt_passwd Password used to decrypt the encrypted `root_key_enc`
class openssh::client (
  $packages        = $::openssh::client::params::packages,
  $packages_ensure = $::openssh::client::params::packages_ensure,
  $config_file     = $::openssh::client::params::config_file,
  $config_augeas   = $::openssh::client::params::config_augeas,
  $augeas_context  = $::openssh::client::params::augeas_context,
  $root_key_enc    = $::openssh::client::params::root_key_enc,
  $root_key_file   = $::openssh::client::params::root_key_file,
  $decrypt_passwd  = $::openssh::client::params::decrypt_passwd,
) inherits openssh::client::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_array($config_augeas)
  validate_absolute_path($augeas_context)
  validate_string($decrypt_passwd)
  validate_absolute_path($root_key_file)
  validate_string($root_key_enc)

  anchor { 'openssh::client::begin': } ->
  class { '::openssh::client::install': } ->
  class { '::openssh::client::config': } ->
  class { '::openssh::client::keys': } ->
  anchor { 'openssh::client::end': }

}
