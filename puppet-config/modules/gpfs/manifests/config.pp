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

#
class gpfs::config inherits gpfs {

  if $config_manage {

    file { $::gpfs::config_file:
      content  => decrypt($::gpfs::config_src, $::gpfs::decrypt_passwd),
      mode     => $::gpfs::file_mode,
    }

    create_resources(gpfs::ssl_key, $::gpfs::ssl_keys)

    # setup GPFS cluster internal SSH public key if defined
    if $::gpfs::ssh_public_key != undef {
      ssh_authorized_key { "gpfs_${::gpfs::cluster}" :
        ensure => 'present',
        key    => $::gpfs::ssh_public_key,
        type   => 'ssh-rsa',
        user   => 'root',
      }
    }

    # setup GPFS cluster internal SSH private key if defined
    if $::gpfs::ssh_private_key_src != undef {
      openssh::client::identity { "gpfs_${::gpfs::cluster}":
        key_enc        => $::gpfs::ssh_private_key_src,
        key_file       => "/root/.ssh/id_rsa_gpfs_${::gpfs::cluster}",
        host           => $::gpfs::ssh_hosts,
        decrypt_passwd => $::gpfs::decrypt_passwd,
      }
    }
  }
}
