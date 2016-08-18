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

# HTTP server for secrets
#
# This http server listen on an alternate port (1216 with common.yaml).
# It serves an alternate document root and is protected by a firewall rules
# that will forbid connection not originating from a port strictly below
# 1024. This ensures the client is root.
#
# This is used by the `hpc-config-apply` script.
#
# ## Profiles dependency
#
# To work properly, this profile also needs:
# * `profiles::firewall::base`
#
# ## Hiera
# * `cluster_prefix`
# * `website_dir`
# * `profiles::http::log_level`
# * `profiles::http::secret::port`
# * `profiles::http::secret::docroot`
# * `profiles::http::serveradmin`
class profiles::http::secret {

  ## Hiera lookups

  $serveradmin    = hiera('profiles::http::serveradmin')
  $log_level      = hiera('profiles::http::log_level')
  $port           = hiera('profiles::http::secret::port')
  $docroot        = hiera('profiles::http::secret::docroot')
  $cluster_prefix = hiera('cluster_prefix')

  include apache

  $servername = "${cluster_prefix}${::puppet_role}"
  # This is hardcoded but, the zone is hardcoded right now (GH issue #45)
  $serveraliases = ["${servername}.cluster"]

  # Pass config options as a class parameter

  apache::vhost { "${servername}_secret":
    servername    => $servername,
    port          => $port,
    docroot       => $docroot,
    serveradmin   => $serveradmin,
    log_level     => $log_level,
    serveraliases => $serveraliases,
  }

  shorewall::rule { 'secret_inbound':
    comment => 'Only authorize connection to secret server from ports < 1024',
    source  => 'clstr',
    dest    => 'fw',
    proto   => 'tcp',
    dport   => $port,
    sport   => '1024:',
    action  => 'REJECT',
    order   => 10,
  }
}
