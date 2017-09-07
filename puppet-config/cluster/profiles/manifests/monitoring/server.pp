##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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


# Setup a monitoring server (icinga satellite and nscang server)
#
# #Hiera
# * `profiles::monitoring::server::listen_from_clients_networks` (`hiera_array`)
#     List of networks the agent receiving notifications from client should listen
#     on, if the list is empty, all interfaces (default: []).
class profiles::monitoring::server {

  $packages              = hiera_array('profiles::monitoring::server::packages', [])
  $features              = hiera_array('profiles::monitoring::server::features', [])
  $features_conf         = hiera_hash('profiles::monitoring::features_conf', {})
  $zones                 = hiera_hash('profiles::monitoring::server::zones', {})
  $endpoints             = hiera_hash('profiles::monitoring::server::endpoints', {})
  $idents                = hiera_hash('profiles::monitoring::server::idents', {})
  $decrypt_password      = hiera('icinga2::decrypt_passwd')
  $notif_script_conf     = hiera('profiles::monitoring::server::notif_script_conf')
  $notif_script_conf_src = hiera('profiles::monitoring::server::notif_script_conf_src')
  $bind_network          = hiera('profiles::monitoring::server::bind_network')
  $nsca_server_listen_networks = hiera_array('profiles::monitoring::server::listen_from_clients_networks', [])

  # get the network hostname of current node on the $bind_network
  $bind_host = $::mymasternet['networks'][$bind_network]['hostname']

  class { '::icinga2':
    packages      => $packages,
    features      => $features,
    features_conf => $features_conf,
    zones         => $zones,
    endpoints     => $endpoints,
    idents        => $idents,
    bind_host     => $bind_host,
  }

  class { '::icinga2::notif':
    notif_script_conf     => $notif_script_conf,
    notif_script_conf_src => $notif_script_conf_src,
    decrypt_password      => $decrypt_password,
  }

  if size($nsca_server_listen_networks) > 0 {
    # If listening interfaces are provided add it to the list of listening
    # addresses in the config (including VIPs)
    $ip_addrs = hpc_net_ip_addrs($nsca_server_listen_networks, true)
    $ip = ['127.0.0.1', $ip_addrs]

  } else {
    $ip = undef
  }

  class { '::nscang::server' :
    listen_addresses => $ip,
  }
  include '::nscang::client'

}
