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

    file { $::gpfs::key_file:
      content  => decrypt($::gpfs::key_src, $::gpfs::decrypt_passwd),
      notify   => Service[$::gpfs::params::service_name],
    }

    ssh_authorized_key { "gpfs_${::gpfs::cluster}" :
      ensure => 'present',
      key    => $::gpfs::public_key,
      type   => 'ssh-rsa',
      user   => 'root',
    }
  }
}
