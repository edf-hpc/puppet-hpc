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

# Setup a proxy for APT repositories
#
# Will install apt-cacher-ng
# # Hiera
# * `listen_networks` (`hiera_array`) List of network the apt-cacher-ng
#     daemon should bind, all if ommited or empty
class profiles::apt::proxy {
  $listen_networks  = hiera_array('profiles::apt::proxy::listen_networks', [])

  if size($listen_networks) > 0 {
    # If listening interfaces are provided add it to the list of listening
    # addresses in the config (including VIPs)
    #
    # VIPs are necessary because during early boot diskless nodes have it
    # configured in their /etc/hosts as apt.service.virtual.
    $ip_addrs = hpc_net_ip_addrs($listen_networks, true)
    $joined_addrs = join($ip_addrs, ' ')
    $config_options = {
      'BindAddress' => "127.0.0.1 ${joined_addrs}",
    }

    ## Sysctl setup
    # We need a sysctl to enable the ip_nonlocal_bind that will permit
    # apache to bind the VIP on de failover node
    kernel::sysctl { 'profiles_apt_proxy':
      params => {
        'net.ipv4.ip_nonlocal_bind' => '1',
      },
    }
  } else {
    $config_options = undef
  }
  class { '::aptcacherng' :
    config_options => $config_options
  }
}
