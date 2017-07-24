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

class conman::params {
  $packages        = [ 'conman' ]
  $packages_ensure = true
  $service         = 'conman'
  $service_ensure  = running
  $service_enable  = true
  $manage_logs     = true
  $logrotate       = true

  # By default override some systemd service parameters for conman daemon:
  # - set high nofile limit because conman daemon opens a lot of FD (2 x node)
  #   with freeipmi library.
  # - define PID file because, on debian, the service is started through a SYSV
  #   init script and, in this case, systemd is not able to track the main
  #   service process (to know whether it has properly started and detect when
  #   it crashes) without this option.
  $service_override_defaults = {
    'Service' => {
      'LimitNOFILE' => '8192',
      'PIDFile'     => '/var/run/conmand.pid',
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

