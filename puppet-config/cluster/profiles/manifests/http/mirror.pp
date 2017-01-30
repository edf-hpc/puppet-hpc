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

# HTTP server for package repository mirrors
#
# ## Hiera
# * `cluster_prefix`
# * `domain`
# * `website_dir`
# * `profiles::http::error_log_file`
# * `profiles::http::log_level`
# * `profiles::http::mirror::docroot`
# * `profiles::http::mirror::hpc_files` (`hiera_hash`) Create resource
#                                       hpclib::hpc_file to add keys
# * `profiles::http::port`
# * `profiles::http::scriptalias`
# * `profiles::http::serveradmin`
class profiles::http::mirror {

  ## Hiera lookups

  $port           = hiera('profiles::http::port')
  $docroot        = hiera('profiles::http::mirror::docroot')
  $serveradmin    = hiera('profiles::http::serveradmin')
  $error_log_file = hiera('profiles::http::error_log_file')
  $log_level      = hiera('profiles::http::log_level')
  $scriptalias    = hiera('profiles::http::scriptalias')
  $website_dir    = hiera('website_dir')
  $cluster_prefix = hiera('cluster_prefix')
  $domain         = hiera('domain')

  include apache

  ensure_resource(file, $website_dir, { ensure => directory})

  $servername = "${cluster_prefix}${::my_http_mirror}"
  $serveraliases = ["${servername}.${domain}"]

  # Pass config options as a class parameter
  apache::vhost { $servername:
    port           => $port,
    docroot        => $docroot,
    serveradmin    => $serveradmin,
    error_log_file => $error_log_file,
    log_level      => $log_level,
    serveraliases  => $serveraliases,
    scriptalias    => $scriptalias,
  }

  $hpc_files = hiera_hash('profiles::http::mirror::hpc_files')
  create_resources(hpclib::hpc_file, $hpc_files)
}
