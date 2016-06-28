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
class profiles::nfs::mounts {

  # Hiera lookups
  $to_mount = hiera_hash('profiles::nfs::to_mount')

  # Initialize nfs_client
  include ::nfs_client
 
  # Mount all the specified directories
  create_resources('::nfs_client::mount', $to_mount)

}
