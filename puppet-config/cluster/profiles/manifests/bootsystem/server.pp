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

# Setup tftp and an http server for boot system
#
# ## Hiera
# * `cluster_prefix`
# * `domain`
# * `boot_params`
# * `profiles::bootsystem::server::tftp_listen_network` Name of the network the TFTP
#     server should listen on, if empty or missing: all networks
# * `profiles::bootsystem::server::listen_networks` (`hiera_array`) List of network
#     the boothttp vhost daemon should bind, all if ommited or empty
#
# ## Relevant Autolookups
# * `boothttp::port`
# * `boothttp::config_dir_http`
# * `boothttp::menu_source`
# * `boothttp::menu_config`
# * `boothttp::hpc_files`
# * `boothttp::archives`
# * `boothttp::install_options`
# * `boottftp::tftp_dir`
# * `boottftp::hpc_files`
class profiles::bootsystem::server {

  $prefix              = hiera('cluster_prefix')
  $domain              = hiera('domain')
  $virtual_address     = $::hostfile["${prefix}${::puppet_role}"]
  $tftp_listen_network = hiera('profiles::bootsystem::server::tftp_listen_network', '')
  $listen_networks     = hiera_array('profiles::bootsystem::server::listen_networks', [])
  $menu_config_options = hiera_hash('boot_params', {})
  $servername          = "${prefix}${::puppet_role}"
  $serveraliases       = ["${servername}.${domain}"]


  # If listening network is provided add it
  if tftp_listen_network != '' {
    $tftp_ip_addrs = hpc_net_ip_addrs([$tftp_listen_network])
    $ip_addr = $tftp_ip_addrs[0]
    $tftp_config_options = {
      'TFTP_ADDRESS' => "${ip_addr}:69",
    }
  } else {
    $tftp_config_options = undef
  }

  class { '::tftp':
    config_options => $tftp_config_options,
  }

  include ::boottftp
  include ::apache

  if size($listen_networks) > 0 {
    # If listening interfaces are provided add it to the list of listening
    # addresses in the config (including VIPs)
    $ip_addrs = hpc_net_ip_addrs($listen_networks, true)
    $ip = ['127.0.0.1', $ip_addrs]


    ## Sysctl setup
    # We need a sysctl to enable the ip_nonlocal_bind that will permit
    # apache to bind the VIP on de failover node
    kernel::sysctl { 'profiles_bootsystem_server':
      params => {
        'net.ipv4.ip_nonlocal_bind' => '1',
      },
    }

  } else {
    $ip = undef

  }

  class { '::boothttp':
    ip                  => $ip,
    virtual_address     => $virtual_address,
    servername          => $servername,
    serveraliases       => $serveraliases,
    menu_config_options => $menu_config_options,
  }

}
