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

class opensshserver::params {

#### Module variables

  $packages_ensure = 'latest'
  $main_config     = '/etc/ssh/sshd_config'
  $augeas_context  = "/files/${main_config}"
  $service         = 'ssh'
  case $::osfamily {
    'Debian' : {
      $packages = ['ssh','openssh-server']
    }
    'RedHat' : {
      $packages = ['openssh','openssh-server']
    }
    default : {
      $packages = ['ssh','openssh-server']
    }
  }
  $root_key_directory  = '/root/.ssh'
  $root_key            = 'id_rsa_root'

#### Defaults values

  $main_config_options = [
    'set MaxStartups 8192',
    'set PermitRootLogin yes',
    'set X11UseLocalhost no',
  ]
  $rootkeys_directory_source = 'puppet:///modules/opensshserver'
  $decrypt_passwd            = 'password'
}
