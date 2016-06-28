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

# Setup a Bitorrent seeder
#
# ## Hiera
# * `cluster`
# * `profiles::p2p::seeder::ctorrent_cfg`
class profiles::p2p::seeder {

  ## Hiera lookups
  $cluster          = hiera('cluster')
  $ctorrent_options = hiera('profiles::p2p::seeder::ctorrent_cfg')

  class { '::ctorrent':
    cluster          => $cluster,
    ctorrent_options => $ctorrent_options,
  }
}
