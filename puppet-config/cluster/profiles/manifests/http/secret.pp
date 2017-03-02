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
# The configuration also ensures that the request are coming from the cluster
# by restricting to the administration network in the vhost configuration and
# with additional shorewall rules forbiding all connections not coming from
# the cluster zone.
#
# localhost has no restrictions.
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

  file { "${docroot}/keys.tar.xz":
    ensure  => present,
    content => decrypt($keys_enc, $keys_password),
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0600',
  }
  file { "${docroot}/index.html":
    ensure  => present,
    content => 'It works.',
    owner   => 'www-data',
    group   => 'www-data',
    mode    => '0600',
  }


  # Apache setup
  $servername = "${cluster_prefix}${::puppet_role}"
  $serveraliases = ["${servername}.${domain}"]

  $role_ip_addr = $::hostfile[$servername]
  $host_ip_addr = $::hostfile[$::hostname]
  if $role_ip_addr {
    $ip_list = ['127.0.0.1', $role_ip_addr, $host_ip_addr]
  } else {
    $ip_list = ['127.0.0.1', $host_ip_addr]
  }
  $admin_net = $::net_topology['administration']
  if $admin_net {
    $admin_net_address = "${admin_net['ipnetwork']}${admin_net['prefix_length']}"
  } else {
    fail('profiles::http::secret needs a defined "administration" network in the \$net_topology fact')
  }
  include apache
  apache::vhost { "${servername}_secret":
    servername    => $servername,
    ip            => $ip_list,
    port          => $port,
    docroot       => $docroot,
    serveradmin   => $serveradmin,
    log_level     => $log_level,
    serveraliases => $serveraliases,
    docroot_mode  => '0750',
    docroot_group => 'www-data',
    directories   => [
      {
        path    => $docroot,
        require => {
          enforce => 'any',
          requires => [
            'local',
            "ip ${admin_net_address}",
          ],
        }
      },
    ]
  }

  # Firewall setup
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
