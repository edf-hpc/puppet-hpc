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

class hpc_rsyslog::server::params {

  $config_manage = true
  $logrotate_rules_defaults = {
    'remotelog' => {
      path          => '/srv/logs/*',
      compress      => true,
      missingok     => true,
      copytruncate  => true,
      create        => false,
      delaycompress => true,
      mail          => false,
      rotate        => '30',
      sharedscripts => true,
      size          => '5M',
      rotate_every  => day,
      postrotate    => 'invoke-rc.d rsyslog rotate > /dev/null',
    }
  }
  $service_name = 'rsyslog'
  $service_override_defaults = {
    'Service' => {
      'LimitNOFILE' => '8192'
    }
  }

}
