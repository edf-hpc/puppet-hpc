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
class profiles::http::diskless {

  ## Hiera lookups
  $serveradmin    = hiera('profiles::http::serveradmin')
  $log_level      = hiera('profiles::http::log_level')
  $port           = hiera('profiles::http::diskless::port')
  $docroot        = hiera('profiles::http::diskless::docroot')
  $cluster_prefix = hiera('cluster_prefix')
  $domain         = hiera('domain')

  include apache

  $servername = "${cluster_prefix}${::puppet_role}"
  $serveraliases = ["${servername}.${domain}"]

  # Pass config options as a class parameter
  apache::vhost { "${servername}_diskless":
    servername    => $servername,
    port          => $port,
    docroot       => $docroot,
    serveradmin   => $serveradmin,
    log_level     => $log_level,
    serveraliases => $serveraliases,
    docroot_mode  => '0750',
    docroot_group => 'www-data',
  }

}
