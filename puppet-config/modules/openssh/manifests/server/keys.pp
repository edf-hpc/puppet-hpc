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

class openssh::server::keys inherits openssh::server {

  if $::openssh::server::root_public_key == $::openssh::server::params::root_public_key {
    notice('The default public root key from the module is in use, this is a MAJOR SECURITY ISSUE.')
  }
  ssh_authorized_key { "root_${::openssh::server::cluster}" :
    ensure => 'present',
    key    => $::openssh::server::root_public_key,
    type   => 'ssh-rsa',
    user   => 'root',
  }

  $files_defaults      = {
  }

  # Host keys
  #
  # Each key is pulled from the source directory with a series of default
  # the private key is pulled and decrypted, the public key is regenerated
  # locally from the private key.
  #
  $search_suffixes = [
    ".${::hostname}.enc",
    ".${::puppet_role}.enc",
    '.default.enc'
  ]
  $target_dir = $::openssh::server::hostkeys_dir
  $source_dir = $::openssh::server::hostkeys_source_dir

  file { "${target_dir}/${::openssh::server::host_private_key_rsa}":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => decrypt(
                prefix(
                  $search_suffixes,
                  "${source_dir}/${::openssh::server::host_private_key_rsa}"
                ),
                $::openssh::server::decrypt_passwd
              ),
  }
  exec { 'openssh_server_update_host_public_key_rsa':
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    command     => "ssh-keygen -y -f ${target_dir}/${::openssh::server::host_private_key_rsa} >  ${target_dir}/${::openssh::server::host_public_key_rsa}",
    refreshonly => true,
    subscribe   => File["${target_dir}/${::openssh::server::host_private_key_rsa}"],
  }

  file { "${target_dir}/${::openssh::server::host_private_key_dsa}":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => decrypt(
                prefix(
                  $search_suffixes,
                  "${source_dir}/${::openssh::server::host_private_key_dsa}"
                ),
                $::openssh::server::decrypt_passwd
              ),
  }
  exec { 'openssh_server_update_host_public_key_dsa':
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    command     => "ssh-keygen -y -f ${target_dir}/${::openssh::server::host_private_key_dsa} >  ${target_dir}/${::openssh::server::host_public_key_dsa}",
    refreshonly => true,
    subscribe   => File["${target_dir}/${::openssh::server::host_private_key_dsa}"],
  }

  file { "${target_dir}/${::openssh::server::host_private_key_ecdsa}":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => decrypt(
                prefix(
                  $search_suffixes,
                  "${source_dir}/${::openssh::server::host_private_key_ecdsa}"
                ),
                $::openssh::server::decrypt_passwd
              ),
  }
  exec { 'openssh_server_update_host_public_key_ecdsa':
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    command     => "ssh-keygen -y -f ${target_dir}/${::openssh::server::host_private_key_ecdsa} >  ${target_dir}/${::openssh::server::host_public_key_ecdsa}",
    refreshonly => true,
    subscribe   => File["${target_dir}/${::openssh::server::host_private_key_ecdsa}"],
  }

  file { "${target_dir}/${::openssh::server::host_private_key_ed25519}":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => decrypt(
                prefix(
                  $search_suffixes,
                  "${source_dir}/${::openssh::server::host_private_key_ed25519}"
                ),
                $::openssh::server::decrypt_passwd
              ),
  }
  exec { 'openssh_server_update_host_public_key_ed25519':
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    command     => "ssh-keygen -y -f ${target_dir}/${::openssh::server::host_private_key_ed25519} >  ${target_dir}/${::openssh::server::host_public_key_ed25519}",
    refreshonly => true,
    subscribe   => File["${target_dir}/${::openssh::server::host_private_key_ed25519}"],
  }

}
