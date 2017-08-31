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

# Setup a minimal configuration for a Ceph cluster
#
# Will install ceph
# * `profiles::ceph::listen_network` (`hiera`) Name of the network the Ceph
#   daemons should listen for incoming connections
class profiles::ceph::server {

  $ceph_config_options = hiera_hash('profiles::ceph::config_options')
  $listen_network = hiera('profiles::ceph::listen_network')

  $_public_network = hpc_net_cidr($listen_network)
  $_cluster_network = hpc_net_cidr($listen_network)
  # Since RadosGW is not able to bind to multiple IP addresses, arbitrary pop
  # the first IP address returned by hpc_net_ip_addrs()
  $_ips = hpc_net_ip_addrs([$listen_network])
  $_rgw_host = $_ips[0]

  class { '::ceph':
    config_options  => $ceph_config_options,
    public_network  => $_public_network,
    cluster_network => $_cluster_network,
    rgw_host        => $_rgw_host,
  }
}
