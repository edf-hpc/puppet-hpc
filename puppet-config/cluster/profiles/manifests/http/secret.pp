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

  $admin_net = $::net_topology['administration']
  if $admin_net {
    $admin_net_address = "${admin_net['ipnetwork']}${admin_net['prefix_length']}"
  } else {
    fail('profiles::http::secret needs a defined "administration" network in the \$net_topology fact')
  }
  include apache
  apache::vhost { "${servername}_secret":
    servername    => $servername,
    ip            => '127.0.0.1',
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

  ## Sysctl setup
  # We need a sysctl to enable the route_localnet that will enable the
  # DNAT on localhost to work
  kernel::sysctl { 'profiles_http_secret':
    params => {
      'net.ipv4.conf.all.route_localnet'     => '1',
      'net.ipv4.conf.default.route_localnet' => '1',
    },
  }

  ## Firewall setup
  $host_ip_addr = $::hostfile[$::hostname]
  # Redirect legitimate traffic incoming to the administration IP
  # address to localhost
  shorewall::rule { 'secret_inbound_clstr_below_1024_redirect':
    comment  => 'Redirect cluster connections to secret server IP address from ports < 1024',
    source   => 'clstr',
    dest     => "fw:127.0.0.1:${port}",
    proto    => 'tcp',
    dport    => $port,
    sport    => ':1023',
    action   => 'DNAT',
    origdest => $host_ip_addr,
    order    => 10,
  }
  shorewall::rule { 'secret_inbound_local_below_1024_redirect':
    comment  => 'Redirect local connections to secret server IP address from ports < 1024',
    source   => 'fw',
    dest     => $port,
    proto    => 'tcp',
    dport    => $port,
    sport    => ':1023',
    action   => 'REDIRECT',
    origdest => $host_ip_addr,
    order    => 10,
  }
  # Authorize legitimate traffic
  shorewall::rule { 'secret_inbound_fw':
    comment  => 'Authorize connection to secret server from localhost',
    source   => 'fw',
    dest     => 'fw',
    proto    => 'tcp',
    dport    => $port,
    action   => 'ACCEPT',
    order    => 11,
  }
  # Reject all the unauthorized traffic from the cluster and just drop
  # outside incoming traffic
  shorewall::rule { 'secret_inbound_clstr_above_1024':
    comment  => 'Only authorize connection to secret server from ports < 1024',
    source   => 'clstr',
    dest     => 'fw',
    proto    => 'tcp',
    dport    => $port,
    sport    => '1024:',
    action   => 'REJECT',
    order    => 11,
  }
  shorewall::rule { 'secret_inbound_notclstr':
    comment => 'Reject all connections to secret server not coming from clstr or fw',
    source  => 'all',
    dest    => 'fw',
    proto   => 'tcp',
    dport   => $port,
    action  => 'DROP',
    order   => 12,
  }
}
