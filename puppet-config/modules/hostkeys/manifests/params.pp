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

class hostkeys::params {

#### Module variables

  $files_defaults      = {
    'ensure' => 'present',
    'owner'  =>  'root',
    'group'  =>  'root',
  }
  $hostkeys_directory  = '/etc/ssh'
  $private_key_rsa     = 'ssh_host_rsa_key'
  $public_key_rsa      = 'ssh_host_rsa_key.pub'
  $private_key_dsa     = 'ssh_host_dsa_key'
  $public_key_dsa      = 'ssh_host_dsa_key.pub'
  $private_key_ecdsa   = 'ssh_host_ecdsa_key'
  $public_key_ecdsa    = 'ssh_host_ecdsa_key.pub'
  $private_key_ed25519 = 'ssh_host_ed25519_key'
  $public_key_ed25519  = 'ssh_host_ed25519_key.pub'
  $hostkeys            = {
    "${private_key_rsa}" => {
      path   => "${hostkeys_directory}/${private_key_rsa}",
      mode   => '0600',
      source => [ "${hostkeys_directory_source}/${private_key_rsa}.${hostname}",
                  "${hostkeys_directory_source}/${private_key_rsa}.${puppet_role}",
                  "${hostkeys_directory_source}/${private_key_rsa}.default", ],
    },
    "${public_key_rsa}" => {
      path   => "${hostkeys_directory}/${public_key_rsa}",
      source => [ "${hostkeys_directory_source}/${public_key_rsa}.${hostname}",
                  "${hostkeys_directory_source}/${public_key_rsa}.${puppet_role}",
                  "${hostkeys_directory_source}/${public_key_rsa}.default", ],
    },
    "${private_key_dsa}" => {
      path   => "${hostkeys_directory}/${private_key_dsa}",
      mode   => '0600',
      source => [ "${hostkeys_directory_source}/${private_key_dsa}.${hostname}",
                  "${hostkeys_directory_source}/${private_key_dsa}.${puppet_role}",
                  "${hostkeys_directory_source}/${private_key_dsa}.default", ],
    },
    "${public_key_dsa}" => {
      path   => "${hostkeys_directory}/${public_key_dsa}",
      source => [ "${hostkeys_directory_source}/${public_key_dsa}.${hostname}",
                  "${hostkeys_directory_source}/${public_key_dsa}.${puppet_role}",
                  "${hostkeys_directory_source}/${public_key_dsa}.default", ],
    },
    "${private_key_ecdsa}" => {
      path   => "${hostkeys_directory}/${private_key_ecdsa}",
      mode   => '0600',
      source => [ "${hostkeys_directory_source}/${private_key_ecdsa}.${hostname}",
                  "${hostkeys_directory_source}/${private_key_ecdsa}.${puppet_role}",
                  "${hostkeys_directory_source}/${private_key_ecdsa}.default", ],
    },
    "${public_key_ecdsa}" => {
      path   => "${hostkeys_directory}/${public_key_ecdsa}",
      source => [ "${hostkeys_directory_source}/${public_key_ecdsa}.${hostname}",
                  "${hostkeys_directory_source}/${public_key_ecdsa}.${puppet_role}",
                  "${hostkeys_directory_source}/${public_key_ecdsa}.default", ],
    },
    "${private_key_ed25519}" => {
      path   => "${hostkeys_directory}/${private_key_ed25519}",
      mode   => '0600',
      source => [ "${hostkeys_directory_source}/${private_key_ed25519}.${hostname}",
                  "${hostkeys_directory_source}/${private_key_ed25519}.${puppet_role}",
                  "${hostkeys_directory_source}/${private_key_ed25519}.default", ],
    },
    "${public_key_ed25519}" => {
      path   => "${hostkeys_directory}/${public_key_dsa}",
      source => [ "${hostkeys_directory_source}/${public_key_ed25519}.${hostname}",
                  "${hostkeys_directory_source}/${public_key_ed25519}.${puppet_role}",
                  "${hostkeys_directory_source}/${public_key_ed25519}.default", ],
    },
  }

#### Defaults values

  $hostkeys_directory_source = 'puppet:///modules/hostkeys'

}
