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

class network::service inherits network {
  if $::network::service_manage {
    service { $::network::service_name:
      ensure => $::network::service_ensure,
      enable => $::network::service_enable,
    }

    # Test the network is really up before proceeding
    exec { 'network_service_ping_gateway':
      refreshonly => true,
      subscribe   => Service[$::network::service_name],
      command     => "/usr/bin/fping -r 30 -t 1000 -B 1 ${::network::defaultgw}",
      # Proceed anyway if host is unreachable
      returns     => [ 0, 1, 2],
    }
  }

}
