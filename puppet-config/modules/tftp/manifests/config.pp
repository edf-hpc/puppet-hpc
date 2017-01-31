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

class tftp::config inherits tftp {

  $service_dir = "/etc/systemd/system/${::tftp::service}.service.d"
  $service_override_file = "${service_dir}/override.conf"

  file { $service_dir:
    ensure => directory,
  }

  hpclib::print_config { $service_override_file:
    style  => 'ini',
    data   => $::tftp::_service_override,
    notify => Exec['tftp_systemctl_daemon_reload'],
  }

  exec { 'tftp_systemctl_daemon_reload':
    refreshonly => true,
    command     => '/bin/systemctl daemon-reload',
    notify      => Class['::tftp::service'],
  }

  hpclib::print_config { $::tftp::config_file :
    style  => 'keyval',
    data   => $::tftp::_config_options,
    notify => Service[$::tftp::service],
  }

}
