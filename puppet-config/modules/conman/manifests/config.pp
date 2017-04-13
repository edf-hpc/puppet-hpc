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

class conman::config inherits conman {
  $service_dir = "/etc/systemd/system/${::conman::service}.service.d"
  $service_override_file = "${service_dir}/override.conf"

  file { $service_dir:
    ensure => directory,
  }

  hpclib::print_config { $service_override_file:
    style  => 'ini',
    data   => $::conman::_service_override,
    notify => Exec['conman_systemctl_daemon_reload'],
  }

  exec { 'conman_systemctl_daemon_reload':
    refreshonly => true,
    command     => '/bin/systemctl daemon-reload',
    notify      => Class['::conman::service'],
  }

  # Config file
  concat { '/etc/conman.conf':
    ensure => present,
    mode   => '0400',
    notify => Class['conman::service'],
  }

  concat::fragment { 'conman_config_header':
    target  => '/etc/conman.conf',
    order   => '01',
    content => template('conman/conman.conf.header.erb'),
  }

  # Logfile
  file { $::conman::_server_options['logdir']:
    ensure => directory,
  }

  # Configure logrotate if not disabled
  if $::conman::logrotate {
    include ::logrotate

    $_server_options = $::conman::_server_options

    logrotate::rule { 'conman':
      path          => "${_server_options['logdir']}/*/console.log",
      compress      => true,
      missingok     => true,
      copytruncate  => false,
      create        => false,
      delaycompress => false,
      mail          => false,
      rotate        => '4',
      sharedscripts => true,
      size          => '5M',
      rotate_every  => week,
      postrotate    => "/bin/systemctl kill -s SIGHUP ${::conman::service}",
      firstaction   => "/bin/systemctl is-active -q ${::conman::service}",
    }
  }


}

