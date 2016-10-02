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


# Get private/public key and add it to config as identity
#
# The private key `key_enc` is decrypted with `hpclib::decrypt` and
# put on the file system. The public key is generated with the same name
# suffixed `.pub`.
#
# An entry is added to the `config_file` like this:
# ```
# Host <$host>
# IdentityFile <$key_file>
# ```
#
# Multiple entries are authorized for the same host, the same key file
# can be re-used for other files and/or hosts.
#
# If the `ensure` parameter is defined as `absent`, the files (private
# and public keys) are removed and the entry is removed from the config
# file
#
# @param key_enc        Encrypted key source
# @param key_file       Target private key file path, same as the
#                       resource name by default
# @param config_file    Add an 'IdentityFile' entry in this SSH config
#                       file (default: '/root/.ssh/config)
# @param host           Host entry in the `config_file` (default: '*')
# @param decrypt_passwd Password used to decrypt the file (default:
#                       'password')
# @param ensure         Ensure the keys have this state, valid values:
#                       'present', 'absent' (default: 'present')
define openssh::client::identity (
  $key_enc,
  $key_file         = $title,
  $config_file      = '/root/.ssh/config',
  $host             = '*',
  $decrypt_passwd   = 'password',
  $ensure           = 'present'
) {
  validate_string($key_enc)
  validate_absolute_path($key_file)
  validate_absolute_path($config_file)
  validate_string($host)
  validate_string($decrypt_passwd)
  if ! ($ensure in [ 'present', 'absent' ]) {
    fail ("Invalid ensure value: ${ensure} ('present', 'absent').")
  }

  # The same key can be used by multiple hosts, so we
  # handle that gracefully if the parameters are the
  # same.
  ensure_resource (
    'file',
    $key_file,
    {
      ensure  => $ensure,
      content => decrypt($key_enc, $decrypt_passwd),
      mode    => '0600',
    },
  )

  if $ensure == 'present' {
    # Create the directory
    ensure_resource(file, dirname($config_file), { ensure => directory })

    # Generate the public key
    exec { "openssh_client_update_public_key_${name}":
      path        => '/bin:/usr/bin:/sbin:/usr/sbin',
      command     => "ssh-keygen -y -f ${key_file} > ${key_file}.pub",
      refreshonly => true,
      subscribe   => File[$key_file],
    }

    # Create the host selector
    augeas { "ssh_config ${config_file} set host ${host} ${key_file}":
      context => "/files/${config_file}",
      changes => [ "set Host[ . = '${host}' ] '${host}' " ],
    }

    # Set the IdentityFile if one this value does not already exists
    augeas { "ssh_config ${config_file} set identityfile ${host} ${key_file}":
      context => "/files/${config_file}",
      changes => [ "set Host[ . = '${host}' ]/IdentityFile[-1] '${key_file}" ],
      onlyif  => "match Host[. = '${host}']/IdentityFile[ . = '${key_file}' ] size == 0",
      require => Augeas["ssh_config ${config_file} set host ${host} ${key_file}"],
    }

  } else {
    # Remove the public key
    ensure_resource (
      'file',
      "${key_file}.pub",
      {
        ensure => absent
      },
    )

    # Remove the IdentityFile entry in the config file
    augeas { "ssh_config ${config_file} rm identityfile ${host} ${key_file}":
      context => "/files/${config_file}",
      changes => [ "rm Host[. = '${host}']/IdentityFile[ . = '${key_file}' ] " ],
    }

  }

}

