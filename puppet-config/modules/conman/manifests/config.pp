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

class conman::config inherits conman {
  # Config file
  concat { '/etc/conman.conf':
    ensure  => present,
    mode    => '0400',
    notify  => Class['conman::service'],
  }

  concat::fragment { 'conman_config_header':
    target  => '/etc/conman.conf',
    order   => '01',
    content => template('conman/conman.conf.header.erb'),
  }

  # Logfile
  file { $_server_options['logdir']:
    ensure => directory,
  }

  # Configure logrotate if not disabled
  if $logrotate {
    include ::logrotate

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
      postrotate    => "/usr/bin/systemctl kill -s SIGHUP ${service}",
      firstaction   => "/usr/bin/systemctl is-active -q ${service}",
    }
  }


}

