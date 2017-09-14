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
# * `profiles::p2p::seeder::ctorrent_options` (`hiera_hash`)
# * `profiles::p2p::seeder::listen_network` Name of the network the seeder will
#      listen on. Only one network is permitted. If '' will listen on all
#      interfaces (default: '')
class profiles::p2p::seeder {

  ## Hiera lookups
  $cluster          = hiera('cluster_name')
  $ctorrent_options = hiera_hash('profiles::p2p::seeder::ctorrent_options')
  $listen_network   = hiera('profiles::p2p::seeder::listen_network', '')

  if $listen_network != '' {
    $ip_addresses = hpc_net_ip_addrs($listen_network)
    $listen_ip_address = $ip_addresses[0]

    if has_key($ctorrent_options, 'misc_options') {
      $base_misc_options = $ctorrent_options['misc_options']
    } else {
      $base_misc_options = ''
    }
    $ctorrent_options_listen = {
      'misc_options' => "${base_misc_options} -i ${listen_ip_address}"
    }
  } else {
    $ctorrent_options_listen = {}
  }

  $ctorrent_options_final = merge($ctorrent_options, $ctorrent_options_listen)

  class { '::ctorrent':
    cluster          => $cluster,
    ctorrent_options => $ctorrent_options_final,
  }
}
