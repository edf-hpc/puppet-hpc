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

class proftpd::config inherits proftpd {
  file { $::proftpd::config_file:
    ensure  => present,
    content => template('proftpd/proftpd.conf.erb'),
  }

  file { "${::proftpd::user_home}":
    ensure => directory,
    group  => 'root',
    owner  => 'root',
    mode   => '0555',
   }

  file { "${::proftpd::user_home}/incoming":
    ensure => directory,
    owner  => $::proftpd::user_name,
    group  => 'root',
    mode   => '0755',
  }

  if $::proftpd::auto_stop {
    $cron_ensure = 'present'
  } else {
    $cron_ensure = 'absent'
  } 
  cron { 'proftpd_autostop': 
    ensure  => $cron_ensure,
    command => "/bin/systemctl stop ${::proftpd::service} 1>/dev/null 2>&1",
    user    => 'root',
    hour    => $::proftpd::auto_stop_hour,  
    minute  => $::proftpd::auto_stop_min,  
  }
}

