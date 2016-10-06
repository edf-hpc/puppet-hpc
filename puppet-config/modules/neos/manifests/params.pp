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

class neos::params {
  $packages = [
    'neos',
    'neos-scenarios-graphical'
  ]
  $packages_ensure = 'installed'

  $config_file = '/etc/neos/neos.conf'
  $config_options_default = {
    'cluster' => {
      'name' => 'mycluster'
    }
  }

  $web_apache_file = '/etc/apache2/conf.d/neos.conf'
  $web_dir         = '/usr/local/neos_web'
}

