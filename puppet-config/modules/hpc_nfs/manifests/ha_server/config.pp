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

class hpc_nfs::ha_server::config inherits hpc_nfs::ha_server {

  $partner = hpc_ha_vip_partner($::hpc_nfs::ha_server::vip_name)

  ::hpc_ha::vip_notify_script { 'hpc_nfs_ha_server':
    ensure   => present,
    vip_name => $::hpc_nfs::ha_server::vip_name,
    content  => template('hpc_nfs/nfs_notify_script.erb'),
  }

  file { '/usr/local/bin/hpc_nfs_ha_server_check.sh':
    ensure  => present,
    content => template('hpc_nfs/nfs_check_script.erb'),
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
  }

  cron { 'hpc_nfs_ha_server_check':
    command => '/usr/local/bin/hpc_nfs_ha_server_check.sh',
    user    => 'root',
    hour    => '*',
    minute  => '*',
  }

  if $::hpc_nfs::ha_server::v4recovery_dir {
    file { '/var/lib/nfs/v4recovery':
      ensure => 'link',
      target => $::hpc_nfs::ha_server::v4recovery_dir,
    }
  }

  include ::logrotate
  logrotate::rule { 'hpc_nfs_ha_server':
    path          => '/var/log/hpc_nfs_ha_server/*.log',
    compress      => true,
    missingok     => true,
    copytruncate  => false,
    create        => false,
    delaycompress => false,
    mail          => false,
    rotate        => '30',
    sharedscripts => true,
    size          => '5M',
    rotate_every  => week,
  }
}
