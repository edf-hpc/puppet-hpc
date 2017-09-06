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

# HTTP server for diskless images and torrent files
#
# ## Hiera
# * `cluster_prefix`
# * `domain`
# * `website_dir`
# * `profiles::http::log_level`
# * `profiles::http::diskless::port`
# * `profiles::http::diskless::docroot`
# * `profiles::http::serveradmin`
# * `profiles::http::diskless::listen_networks` (`hiera_array`) List of network
#     the diskless vhost daemon should bind, all if ommited or empty
class profiles::http::diskless {

  ## Hiera lookups
  $serveradmin     = hiera('profiles::http::serveradmin')
  $log_level       = hiera('profiles::http::log_level')
  $port            = hiera('profiles::http::diskless::port')
  $docroot         = hiera('profiles::http::diskless::docroot')
  $listen_networks = hiera_array('profiles::http::diskless::listen_networks', [])
  $cluster_prefix  = hiera('cluster_prefix')
  $domain          = hiera('domain')

  include apache

  $servername = "${cluster_prefix}${::puppet_role}"
  $serveraliases = ["${servername}.${domain}"]

  if size($listen_networks) > 0 {
    # If listening interfaces are provided add it to the list of listening
    # addresses in the config (including VIPs)
    $ip_addrs = hpc_net_ip_addrs($listen_networks, true)
    $ip = ['127.0.0.1', $ip_addrs]

    ## Sysctl setup
    # We need a sysctl to enable the ip_nonlocal_bind that will permit
    # apache to bind the VIP on de failover node
    kernel::sysctl { 'profiles_http_diskless':
      params => {
        'net.ipv4.ip_nonlocal_bind' => '1',
      },
    }

  } else {
    $ip = undef

  }

  # Pass config options as a class parameter
  apache::vhost { "${servername}_diskless":
    servername    => $servername,
    ip            => $ip,
    port          => $port,
    docroot       => $docroot,
    serveradmin   => $serveradmin,
    log_level     => $log_level,
    serveraliases => $serveraliases,
    docroot_mode  => '0750',
    docroot_group => 'www-data',
  }

}
