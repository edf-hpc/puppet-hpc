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

  file { $gpfs::cl_config_dir :
    ensure           => 'directory',
  }

  # Configuration files to install
  # It is assumed specified configuration files are encrypted
  $gpfs_cl_files = {
    "${gpfs::cl_config}" => {
      content  => decrypt($gpfs::cl_config_src, $gpfs::cl_decrypt_passwd),
      mode     => $gpfs::cl_file_mode,
    },
    "${gpfs::cl_key}" => {
      content  => decrypt($gpfs::cl_key_src, $gpfs::cl_decrypt_passwd),
      notify           => Service[$gpfs::params::service],
    },
  }
  # Default settings to apply to all files
  $gpfs_cl_files_def = {
    require    => Package[$gpfs::cl_packages],
  }
  create_resources(file,$gpfs_cl_files,$gpfs_cl_files_def)

  ssh_authorized_key { "gpfs_${::gpfs::cluster}" :
    ensure => 'present',
    key    => $::gpfs::public_key,
    type   => 'ssh-rsa',
    user   => 'root',
  }

}
