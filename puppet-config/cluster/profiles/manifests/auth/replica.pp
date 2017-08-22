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

class profiles::auth::replica {

  ## Hiera lookups

  $directory_source = hiera('profiles::auth::replica::directory_source')
  $ldif_file        = hiera('profiles::auth::replica::ldif_file')
  $ldif_directory   = hiera('profiles::auth::replica::ldif_directory')
  $listen_networks  = hiera_array('profiles::auth::replica::listen_networks', [])

  # If listening interfaces are provided add it to the list of listening
  # URIS in /etc/default/slapd
  if size($listen_networks) > 0 {
    $ip_addrs = hpc_net_ip_addrs($listen_networks)
    $uris = prefix($ip_addrs, 'ldaps://')
    $joined_uris = join($uris, ' ')
    $default_options = {
      'SLAPD_SERVICES' => "'ldapi:// ${joined_uris}'",
    }
  } else {
    $default_options = undef
  }

  # Pass config options as a class parameter
  include certificates

  class { '::openldap' :
    default_options => $default_options,
  }

  class { '::openldap::replica' :
    directory_source => $directory_source,
    ldif_file        => $ldif_file,
    ldif_directory   => $ldif_directory,
  }
}
