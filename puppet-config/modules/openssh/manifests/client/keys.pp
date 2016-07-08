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

class openssh::client::keys inherits openssh::client {
  $root_key_dir = dirname($::openssh::client::root_key_file)
  file { $root_key_dir:
    ensure => directory,
  }

  file { $::openssh::client::root_key_file:
    ensure  => present,
    content => decrypt($::openssh::client::root_key_enc, $::openssh::client::decrypt_passwd),
    mode    => '0600',
  }

  exec { 'openssh_client_update_root_public_key':
    path        => '/bin:/usr/bin:/sbin:/usr/sbin',
    command     => "ssh-keygen -y -f ${::openssh::client::root_key_file} > ${::openssh::client::root_key_file}.pub",
    refreshonly => true,
    subscribe   => File[$::openssh::client::root_key_file],
  }


}
