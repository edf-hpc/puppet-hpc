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

# HTTP server for system files (apt and hpc-config)
#
# This is meant to replace s3-system when ceph is not available.
# File sync between the servers must be handled elsewhere
#
# ## Hiera
# * `cluster_prefix`
# * `domain`
# * `website_dir`
# * `profiles::http::log_level`
# * `profiles::http::system::port`
# * `profiles::http::system::docroot`
# * `profiles::http::serveradmin`
# * `profiles::bootsystem::server::listen_networks` (`hiera_array`) List of network
#     the system vhost daemon should bind, all if ommited or empty
class profiles::http::system {

  ## Hiera lookups
  $serveradmin     = hiera('profiles::http::serveradmin')
  $log_level       = hiera('profiles::http::log_level')
  $port            = hiera('profiles::http::system::port')
  $docroot         = hiera('profiles::http::system::docroot')
  $listen_networks = hiera_array('profiles::http::system::listen_networks', [])
  $cluster_prefix  = hiera('cluster_prefix')
  $domain          = hiera('domain')

  include apache

  $servername = "${cluster_prefix}${::puppet_role}"
  $serveraliases = ["${servername}.${domain}"]

  # If listening interfaces are provided add it to the list of listening
  # addresses in the config
  if size($listen_networks) > 0 {
    $ip_addrs = hpc_net_ip_addrs($listen_networks)
    $ip = ['127.0.0.1', $ip_addrs]
  } else {
    $ip = undef
  }

  # Pass config options as a class parameter
  apache::vhost { "${servername}_system":
    servername    => $servername,
    ip            => $ip,
    port          => $port,
    docroot       => $docroot,
    serveradmin   => $serveradmin,
    log_level     => $log_level,
    serveraliases => $serveraliases,
    directories   => [
      { path            => $docroot,
        php_admin_flags => [ 'engine' ],
        options         => ['Indexes', 'FollowSymLinks', 'MultiViews']
      },
    ],
    docroot_mode  => '0750',
    docroot_group => 'www-data',
  }

  $hpc_files = hiera_hash('profiles::http::system::hpc_files')
  create_resources(hpclib::hpc_file, $hpc_files)
}
