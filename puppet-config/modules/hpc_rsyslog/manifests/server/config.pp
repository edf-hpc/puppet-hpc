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

class hpc_rsyslog::server::config inherits hpc_rsyslog::server {

  if $::hpc_rsyslog::server::config_manage {

    create_resources(logrotate::rule,
                     $::hpc_rsyslog::server::_logrotate_rules)

    $service_dir = "/etc/systemd/system/${::hpc_rsyslog::server::service_name}.service.d"
    $service_override_file = "${service_dir}/override.conf"

    file { $service_dir:
      ensure => directory,
    }

    hpclib::print_config { $service_override_file:
      style  => 'ini',
      data   => $::hpc_rsyslog::server::_service_override,
      notify => Exec['rsyslog_systemctl_daemon_reload'],
    }

    exec { 'rsyslog_systemctl_daemon_reload':
      refreshonly => true,
      command     => '/bin/systemctl daemon-reload',
      notify      => Class['::rsyslog::service'],
    }

  }

}
