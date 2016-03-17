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

class opensshclient::params {

#### Module variables

  $packages_ensure = 'latest'
  $main_config     = '/etc/ssh/ssh_config'
  $augeas_context  = '/files/etc/ssh/ssh_config/Host'
  case $::osfamily {
    'Debian' : {
      $packages = ['openssh-client']
    }
    'RedHat' : {
      $packages = ['openssh-client']
    }
    default : {
      $packages = ['openssh-client']
    }
  }

#### Defaults values

  $main_config_options = [
    'set StrictHostKeyChecking no',
  ]

}
