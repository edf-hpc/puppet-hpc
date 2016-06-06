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

class hostkeys (
  $private_key_rsa           = $hostkeys::params::private_key_rsa,
  $public_key_rsa            = $hostkeys::params::public_key_rsa,
  $private_key_dsa           = $hostkeys::params::private_key_dsa,
  $public_key_dsa            = $hostkeys::params::public_key_dsa,
  $private_key_ecdsa         = $hostkeys::params::private_key_ecdsa,
  $public_key_ecdsa          = $hostkeys::params::public_key_ecdsa,
  $private_key_ed25519       = $hostkeys::params::private_key_ed25519,
  $public_key_ed25519        = $hostkeys::params::public_key_ed25519,
  $hostkeys_directory        = $hostkeys::params::hostkeys_directory,
  $directory_source = $hostkeys::params::directory_source,
) inherits hostkeys::params {

  validate_string($private_key_rsa)
  validate_string($public_key_rsa)
  validate_string($private_key_dsa)
  validate_string($public_key_dsa)
  validate_string($private_key_ecdsa)
  validate_string($public_key_ecdsa)
  validate_string($private_key_ed25519)
  validate_string($public_key_ed25519)
  validate_absolute_path($hostkeys_directory)

  $hostkeys = {
    "${private_key_rsa}" => {
      path   => "${hostkeys_directory}/${private_key_rsa}",
      mode   => '0600',
      source => [ "${directory_source}/${private_key_rsa}.${hostname}",
                  "${directory_source}/${private_key_rsa}.${puppet_role}",
                  "${directory_source}/${private_key_rsa}.default", ],
    },
    "${public_key_rsa}" => {
      path   => "${hostkeys_directory}/${public_key_rsa}",
      source => [ "${directory_source}/${public_key_rsa}.${hostname}",
                  "${directory_source}/${public_key_rsa}.${puppet_role}",
                  "${directory_source}/${public_key_rsa}.default", ],
    },
    "${private_key_dsa}" => {
      path   => "${hostkeys_directory}/${private_key_dsa}",
      mode   => '0600',
      source => [ "${directory_source}/${private_key_dsa}.${hostname}",
                  "${directory_source}/${private_key_dsa}.${puppet_role}",
                  "${directory_source}/${private_key_dsa}.default", ],
    },
    "${public_key_dsa}" => {
      path   => "${hostkeys_directory}/${public_key_dsa}",
      source => [ "${directory_source}/${public_key_dsa}.${hostname}",
                  "${directory_source}/${public_key_dsa}.${puppet_role}",
                  "${directory_source}/${public_key_dsa}.default", ],
    },
    "${private_key_ecdsa}" => {
      path   => "${hostkeys_directory}/${private_key_ecdsa}",
      mode   => '0600',
      source => [ "${directory_source}/${private_key_ecdsa}.${hostname}",
                  "${directory_source}/${private_key_ecdsa}.${puppet_role}",
                  "${directory_source}/${private_key_ecdsa}.default", ],
    },
    "${public_key_ecdsa}" => {
      path   => "${hostkeys_directory}/${public_key_ecdsa}",
      source => [ "${directory_source}/${public_key_ecdsa}.${hostname}",
                  "${directory_source}/${public_key_ecdsa}.${puppet_role}",
                  "${directory_source}/${public_key_ecdsa}.default", ],
    },
    "${private_key_ed25519}" => {
      path   => "${hostkeys_directory}/${private_key_ed25519}",
      mode   => '0600',
      source => [ "${directory_source}/${private_key_ed25519}.${hostname}",
                  "${directory_source}/${private_key_ed25519}.${puppet_role}",
                  "${directory_source}/${private_key_ed25519}.default", ],
    },
    "${public_key_ed25519}" => {
      path   => "${hostkeys_directory}/${public_key_ed25519}",
      source => [ "${directory_source}/${public_key_ed25519}.${hostname}",
                  "${directory_source}/${public_key_ed25519}.${puppet_role}",
                  "${directory_source}/${public_key_ed25519}.default", ],
    },
  }


  anchor { 'hostkeys::begin': } ->
  class { '::hostkeys::config': } ->
  anchor { 'hostkeys::end': }

}
