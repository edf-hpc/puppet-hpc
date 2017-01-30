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

class hpcstats::jobstats::params {
  $packages = [
    'hpcstats-jobstats-agent',
  ]
  $packages_ensure = 'installed'

  $config_file = '/etc/hpcstats/jobstats.conf'
  $config_options_default = {
    'global' => {
      'tpl'    => '/usr/share/hpcstats/bin/jobstats.tpl.sh',
      'script' => '/tmp/jobstats.sh',
      'subcmd' => 'sbatch',
    },
    'vars' => {
      'name'      => 'STATS',
      'ntasks'    => '1',
      'error'     => '/tmp/jobstats.err.log',
      'output'    => '/tmp/jobstats.out.log',
      'partition' => 'cn',
      'time'      => '5',
      'qos'       => 'default',
      'wckey'     => '',
      'fs'        => '/home',
      'log'       => '/tmp/jobstats.log',
    }
  }
}

