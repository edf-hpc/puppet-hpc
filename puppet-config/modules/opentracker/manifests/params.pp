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

class opentracker::params {

  #### Module variables
  $packages_ensure = 'latest'
  $packages        = ['opentracker']
  $config_dir      = '/etc/opentracker'
  $config_file     = 'opentracker.conf'
  $default_file    = '/etc/default/opentracker'
  $service         = 'opentracker'

  #### Defaults values
  $opentracker_default_options = {
    'CONF_FILE' => "${config_dir}/${config_file}",
    'PORT' => 6881,
  }

  $systemd_service_file         = '/etc/systemd/system/opentracker.service'
  $systemd_service_file_options = {
    'Unit'    => {
      'Description'         => 'Service file for opentracker',
      'After'               => 'network.target auditd.service',
      'ConditionPathExists' => '!/etc/no_p2p_server',
    },
    'Service' => {
      'EnvironmentFile'     => '-/etc/default/opentracker',
      'ExecStart'           => '/usr/bin/opentracker -f $CONF_FILE -p $PORT',
      'KillMode'            => 'process',
      'Restart'             => 'on-failure',
    },
    'Install' => {
      'WantedBy'            => 'multi-user.target',
    },
  }

}
