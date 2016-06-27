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

class munge::params {


  ### Service ###
  $service_name      = 'munge'
  $service_enable    = true
  $service_ensure    = 'running'
  $service_manage    = true

  ### Configuration ###
  $auth_key_path     = '/etc/munge'
  $auth_key_name     = "${auth_key_path}/munge.key"
  $auth_key_source   = 'munge/munge.key.enc'
  $auth_key_owner    = 'munge'
  $decrypt_passwd    = 'password'
  $auth_key_mode     = '0400'



  ### Package ###
  $package_ensure    = 'present'
  case $::osfamily {
    'RedHat': {
      $package_manage =  true
      $package_name = ['munge', 'slurm-munge']
    }
    'Debian': {
      $package_manage =  true
      $package_name = ['munge']
    }
    default: {
      $package_manage =  false
    }
  }
}
