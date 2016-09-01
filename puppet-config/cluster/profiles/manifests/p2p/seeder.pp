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

# Bitorrent seeder
#
# P2P boot system uses ctorrent as a seeder for the diskless images.
#
# ## Ctorrent
# Ctorrent is configured with the hiera key
# `profiles::p2p::seeder::ctorrent_options`, used to generate the file
# `/etc/default/ctorrent` witch control options for the ctorrent service like
# file(s) to seed, torrent file and daemon options.
#
# ## Hiera
# * `cluster`
# * `profiles::p2p::seeder::ctorrent_options`
class profiles::p2p::seeder {

  ## Hiera lookups
  $cluster          = hiera('cluster_name')
  $ctorrent_options = hiera('profiles::p2p::seeder::ctorrent_options')

  class { '::ctorrent':
    cluster          => $cluster,
    ctorrent_options => $ctorrent_options,
  }
}
