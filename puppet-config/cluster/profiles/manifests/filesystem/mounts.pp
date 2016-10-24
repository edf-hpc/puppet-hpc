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

# Configure other File System mounts
#
# This profile lets you define file system mounts in hiera. It only
# defines the mounts and does not handle creating the mount points.
#
# NFS mounts should be handled by `profiles::nfs::mounts`.
#
# ## Hiera
# * `profiles::filesystem::mounts` (`hiera_hash`) Hash with the puppet
#                                 `mount` resources to create.
class profiles::filesystem::mounts {

  # Hiera lookups
  $to_mount = hiera_hash('profiles::filesystem::mounts')

  # Mount all the specified directories
  debug("File systems to mount: ${to_mount}")
  create_resources('mount', $to_mount)

}
