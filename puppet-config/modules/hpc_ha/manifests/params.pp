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

class hpc_ha::params {
  $default_notify_script = '/usr/local/bin/hpc_ha_notify.sh'
  $delay_loop = '5'
  $persistence_timeout = '600'
  $service                    = 'keepalived isc-dhcp-server'
  $systemd_config_file        = "/etc/systemd/system/${service}.service"
  $systemd_config_options     = {
    'Unit'    => {
      'Description' => 'LVS and VRRP High Availability Monitor',
      'After'       => 'libvirtd.target syslog.target network.target',
    },
    'Service' => {
      'Type'      => 'forking',
      'KillMode'  => 'process',
      'ExecStart' => '/usr/sbin/keepalived',
    },
    'Install' => {
      'WantedBy' => 'multi-user.target',
    },
  }

  $service_manage = true
  $service_state  = 'enabled'

}
