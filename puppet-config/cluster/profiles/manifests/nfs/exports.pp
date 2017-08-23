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

# Configure NFS server exports
#
# ## Hiera
# * `profiles::nfs::to_export` (`hiera_hash`)
class profiles::nfs::exports {

  # Hiera lookups
  $to_export = hiera_hash('profiles::nfs::to_export')

  # Install NFS common utilities. The rpcbind service must not be disabled on HA
  # NFS servers because it is required by the showmount command used in HA check
  # script.
  $disable_rpcbind = !hpc_has_profile('nfs::ha_server')
  class { '::nfs':
    disable_rpcbind => $disable_rpcbind,
  }
  # Initialize nfs_server
  include ::nfs::server

  # Mount all the specified directories
  create_resources('::nfs::server::export', $to_export)

}
