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

# GPFS -  Node
#
# ## Hiera
#
# * `profiles::gpfs::cluster`  Name of current node GPFS cluster
# * `profiles::gpfs::clusters  Hash of all GPFS clusters settings
#
# ## Relevant autolookups
#
# * `gpfs::decrypt_passwd`
class profiles::gpfs::node {

  # Hiera lookups
  $cluster = hiera('profiles::gpfs::cluster')
  $clusters = hiera_hash('profiles::gpfs::clusters')
  $settings = $clusters[$cluster]

  # Install GPFS node software components
  class { '::gpfs':
    cluster    => $cluster,
    public_key => $settings['pubkey'],
    key_src    => $settings['key_src'],
    config_src => $settings['config_src'],
  }

  # Make sure all potential NFS mount have been realized before realizing the
  # GPFS client class. When GPFS client starts, it first add a line to fstab
  # which is expected by the mount command that it is run afterwhile (~3s). It
  # seems there is a (yet unexplained) "conflict" with Puppet modifications of
  # fstab happening with the Mount resources of the nfs module in the meantime.
  # The observation was that the GPFS line vanished from the fstab when the GPFS
  # mount command is run. To avoid this conflicting corner case, make sure the
  # potential NFS mounts are processed before the GPFS client class.
  Mount <| tag == 'nfs' |> -> Class['::gpfs']

}
