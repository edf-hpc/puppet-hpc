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

# Configure NFS client mount
#
# ## Hiera
# * `profiles::nfs::to_mount` (`hiera_hash`)
# * `profiles::auth::client::enable_kerberos`
class profiles::nfs::mounts {

  # Hiera lookups
  $to_mount = hiera_hash('profiles::nfs::to_mount')

  # If kerberos is enabled it should be configured before starting
  # nfs-common.
  $enable_kerberos = hiera('profiles::auth::client::enable_kerberos')
  if $enable_kerberos {
    Class['kerberos::config'] ~> Class['nfs::service']
  }

  # Initialize nfs_client
  class{ 'nfs':
    enable_gssd => $enable_kerberos
  }

  # Mount all the specified directories
  create_resources('::nfs::client::mount', $to_mount)

}
