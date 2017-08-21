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
class profiles::http::system {

  ## Hiera lookups
  $serveradmin    = hiera('profiles::http::serveradmin')
  $log_level      = hiera('profiles::http::log_level')
  $port           = hiera('profiles::http::system::port')
  $docroot        = hiera('profiles::http::system::docroot')
  $cluster_prefix = hiera('cluster_prefix')
  $domain         = hiera('domain')

  include apache

  $servername = "${cluster_prefix}${::puppet_role}"
  $serveraliases = ["${servername}.${domain}"]

  # Pass config options as a class parameter
  apache::vhost { "${servername}_system":
    servername    => $servername,
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
