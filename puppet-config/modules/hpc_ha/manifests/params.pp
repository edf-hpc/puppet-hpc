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

class hpc_ha::params {
  $default_notify_script = '/usr/local/bin/hpc_ha_notify.sh'
  $sysctl_file           = 'hatuning.conf'

  # disable martian logging since normal with VLAN with multiple IP networks
  $sysctl_options = {
    'net.ipv4.conf.all.log_martians' => '0',
    "net.ipv4.conf.${mynet_topology[wan][interfaces]}.arp_ignore" => '1',  
    "net.ipv4.conf.${mynet_topology[wan][interfaces]}.arp_announce" => '2',
  }
}
