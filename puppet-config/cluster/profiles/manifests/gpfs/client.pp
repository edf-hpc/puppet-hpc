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

# GPFS -  Client
#
# ## Hiera
# * `cluster_name`

class profiles::gpfs::client {

  # Hiera lookups
  $cluster = hiera('cluster_name')

  # Install gpfs client
  class { '::gpfs::client':
    cluster => $cluster,
  }

  # Make sure all potential NFS mount have been realized before realizing the
  # GPFS client class. When GPFS client starts, it first add a line to fstab
  # which is expected by the mount command that it is run afterwhile (~3s). It
  # seems there is a (yet unexplained) "conflict" with Puppet modifications of
  # fstab happening with the Mount resources of the nfs module in the meantime.
  # The observation was that the GPFS line vanished from the fstab when the GPFS
  # mount command is run. To avoid this conflicting corner case, make sure the
  # potential NFS mounts are processed before the GPFS client class.
  Mount <| tag == 'nfs' |> -> Class['::gpfs::client']

}
