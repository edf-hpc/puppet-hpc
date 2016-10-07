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

class carboncrelay::config inherits carboncrelay {
  $service_dir = "/etc/systemd/system/${::carboncrelay::service}.service.d"
  $service_override_file = "${service_dir}/override.conf"

  file { $service_dir:
    ensure => directory,
  }

  hpclib::print_config { $service_override_file:
    style  => 'ini',
    data   => $::carboncrelay::_service_override,
    notify => Exec['carboncrelay_systemctl_daemon_reload'],
  }

  exec { 'carboncrelay_systemctl_daemon_reload':
    refreshonly => true,
    command     => '/bin/systemctl daemon-reload',
    notify      => Class['::carboncrelay::service'],
  }

  concat { $::carboncrelay::config_file:
    ensure => present,
    notify => Class['::carboncrelay::service'],
  }
  concat::fragment { 'carboncrelay_config_header':
    target  => $::carboncrelay::config_file,
    order   => '01',
    content => template('carboncrelay/config.header.erb'),
  }
  Concat::Fragment <| target == $::carboncrelay::config_file |>

}

