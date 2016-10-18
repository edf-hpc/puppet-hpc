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

#
class gpfs::client::config inherits gpfs::client {

  file { $gpfs::client::cl_config_dir :
    ensure           => 'directory'
  }

  # Configuration files to install
  # It is assumed specified configuration files are encrypted
  $gpfs_cl_files = {
    "${gpfs::client::cl_config}" => {
      content  => decrypt($gpfs::client::cl_config_src, $gpfs::client::cl_decrypt_passwd),
      mode     => $gpfs::client::cl_file_mode,
    },
    "${gpfs::client::cl_key}" => {
      content  => decrypt($gpfs::client::cl_key_src, $gpfs::client::cl_decrypt_passwd),
    },
  }
  # Default settings to apply to all files
  $gpfs_cl_files_def = {
    require    => Package[$gpfs::client::cl_packages],
  }
  create_resources(file,$gpfs_cl_files,$gpfs_cl_files_def)

  ssh_authorized_key { "gpfs_${::gpfs::client::cluster}" :
    ensure => 'present',
    key    => $::gpfs::client::public_key,
    type   => 'ssh-rsa',
    user   => 'root',
  }

}
