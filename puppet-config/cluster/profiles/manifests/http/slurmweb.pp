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

# HTTP server for slurm-web API
#
# ## Hiera
# * `cluster_prefix`
# * `profiles::http::port`
# * `profiles::http::slurmweb::docroot`
# * `profiles::http::serveradmin`
# * `profiles::http::error_log_file`
# * `profiles::http::log_level`
# * `profiles::http::slurmweb::packages` (`hiera_array`)
class profiles::http::slurmweb {

  ## Hiera lookups

  $port           = hiera('profiles::http::port')
  $docroot        = hiera('profiles::http::slurmweb::docroot')
  $serveradmin    = hiera('profiles::http::serveradmin')
  $error_log_file = hiera('profiles::http::error_log_file')
  $log_level      = hiera('profiles::http::log_level')
  $cluster_prefix = hiera('cluster_prefix')
  $packages       = hiera_array('profiles::http::slurmweb::packages')

  # Pass config options as a class parameter

  include apache

  apache::vhost { "${hostname}" :
    port           => $port,
    docroot        => $docroot,
    serveradmin    => $serveradmin,
    error_log_file => $error_log_file,
    log_level      => $log_level,
  } ->

  package { "${packages}" :
    ensure => latest,
  }

  exec { 'a2enconf-javascript-common' :
    command => '/usr/sbin/a2enconf javascript-common',
    creates => '/etc/apache2/conf-enabled/javascript-common.conf',
    require => Package[$packages],
  }

  exec { 'a2enconf-slurm-web-restapi' :
    command => '/usr/sbin/a2enconf slurm-web-restapi',
    creates => '/etc/apache2/conf-enabled/slurm-web-restapi.conf',
    require => Package[$packages],
  }

}
