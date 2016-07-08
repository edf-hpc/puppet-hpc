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

class openssh::client::params {

  #### Module variables
  $packages_ensure = 'latest'
  $config_file     = '/etc/ssh/ssh_config'
  $augeas_context  = "/files${config_file}/Host"
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
  $config_augeas = [
    'set StrictHostKeyChecking no',
  ]

  $root_key_file  = '/root/.ssh/id_rsa'
  $root_key_enc   = 'puppet:///modules/openssh/id_rsa_root.enc'
  $decrypt_passwd = 'password'
}
