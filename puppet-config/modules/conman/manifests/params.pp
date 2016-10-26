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

class conman::params {
  $packages        = [ 'conman' ]
  $packages_ensure = true
  $service         = 'conman'
  $service_ensure  = running
  $service_enable  = true
  $logrotate       = true

  $service_override_defaults = {
    'Service' => {
      'LimitNOFILE' => '8192'
    }
  }

  $server_options_default = {
    'logdir'    => '/var/log/conman',
    'pidfile'   => '/var/run/conmand.pid',
    'syslog'    => 'local1',
    'timestamp' => '5m',
  }

  $global_options_default = {
    'logopts'  => 'lock,sanitize,timestamp',
    'log'      => '%N/console.log',
    'seropts'  => '115200,8n1',
    'ipmiopts' => 'U:admin,P:admin',
  }
}

