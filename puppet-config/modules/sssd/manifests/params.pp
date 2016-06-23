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

class sssd::params {

#### Module variables

  $packages_ensure = 'latest'
  $config_dir      = '/etc/sssd'
  $config_file     = "${config_dir}/sssd.conf"
  case $::osfamily {
    'Debian' : {
      $packages = ['sssd', 'libnss-sss']
    }
    'RedHat' : {
      $packages = ['sssd', 'sssd-client']
    }
    default : {
      $packages = ['sssd', 'libnss-sss']
    }
  }
  $default_file    = '/etc/default/sssd'
  $service         = 'sssd'
#### Defaults values
  $enable_kerberos = false
  $default_options = {
    'DAEMON_OPTS'  => '" -D -f" ',
    'VERBOSE'      => '1',
  }

}
