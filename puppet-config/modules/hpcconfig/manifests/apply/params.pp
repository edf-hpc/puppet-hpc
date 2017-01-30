#########################################################################
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

class hpcconfig::apply::params {
  $packages                 = ['hpc-config-apply']
  $packages_ensure          = 'latest'
  $config_file              = '/etc/hpc-config.conf'
  $config_options_defaults  = {
    'DEFAULT' => {
      environment => {
        value => 'production',
      },
      tmpdir      => {
        comment => 'Using /var/tmp to more easily manipulate /tmp mountpoint during a puppet run.',
        value   => '/var/tmp',
      },
    },
  }

}
