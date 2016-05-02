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
  $pkgs        = [ 'conman' ]
  $pkgs_ensure = true
  $serv        = 'conman'
  $serv_ensure = running
  $serv_enable = true
  $logrotate   = true

  $server_opts_defaults = {
    'logdir'    => '/var/log/conman',
    'pidfile'   => '/var/run/conmand.pid',
    'syslog'    => 'local1',
    'timestamp' => '5m',
  }

  $global_opts_defaults = {
    'logopts'  => 'lock,sanitize,timestamp',
    'log'      => '%n/console.log',
    'seropts'  => '115200,8n1',
    'ipmiopts' => 'U:admin,P:admin',
  }
}

