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
# * `domain`
# * `profiles::http::log_level`
# * `profiles::http::secret::port`
# * `profiles::http::secret::docroot`
# * `profiles::http::secret::keys_enc` Encrypted source of the keys
# * `profiles::http::secret::keys_password` Password encrypting the keys
# * `profiles::http::serveradmin`
class profiles::http::secret {

  ## Hiera lookups

  $serveradmin    = hiera('profiles::http::serveradmin')
  $log_level      = hiera('profiles::http::log_level')
  $port           = hiera('profiles::http::secret::port')
  $docroot        = hiera('profiles::http::secret::docroot')
  $keys_enc       = hiera('profiles::http::secret::keys_enc')
  $keys_password  = hiera('profiles::http::secret::keys_password')
  $cluster_prefix = hiera('cluster_prefix')
  $domain         = hiera('domain')

  include apache

  $servername = "${cluster_prefix}${::puppet_role}"
  $serveraliases = ["${servername}.${domain}"]

  file { "${docroot}/keys.tar.xz":
    ensure  => present,
    content => decrypt($keys_enc, $keys_password),
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0600',
  }


  # Pass config options as a class parameter
  apache::vhost { "${servername}_secret":
    servername    => $servername,
    port          => $port,
    docroot       => $docroot,
    serveradmin   => $serveradmin,
    log_level     => $log_level,
    serveraliases => $serveraliases,
    docroot_mode  => '0750',
    docroot_group => 'www-data',
  }

  shorewall::rule { 'secret_inbound_clstr_below_1024':
    comment => 'Authorize connection to secret server from ports < 1024',
    source  => 'clstr',
    dest    => 'fw',
    proto   => 'tcp',
    dport   => $port,
    sport   => ':1023',
    action  => 'ACCEPT',
    order   => 10,
  }
  shorewall::rule { 'secret_inbound_fw':
    comment => 'Authorize connection to secret server from ports < 1024',
    source  => 'fw',
    dest    => 'fw',
    proto   => 'tcp',
    dport   => $port,
    action  => 'ACCEPT',
    order   => 10,
  }
  shorewall::rule { 'secret_inbound_clstr_above_1024':
    comment => 'Only authorize connection to secret server from ports < 1024',
    source  => 'clstr',
    dest    => 'fw',
    proto   => 'tcp',
    dport   => $port,
    sport   => '1024:',
    action  => 'REJECT',
    order   => 10,
  }
  shorewall::rule { 'secret_inbound_notclstr':
    comment => 'Reject all connections to secret server not coming from clstr or fw',
    source  => 'all',
    dest    => 'fw',
    proto   => 'tcp',
    dport   => $port,
    action  => 'REJECT',
    order   => 11,
  }
}
