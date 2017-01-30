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

# Mount a POSIX Ceph FS
#
# When using the kernel module, servers must be provided here. The FUSE
# mode uses the configuration in /etc/ceph/ceph.conf.
#
# @param servers    Array of Ceph MON servers (not supported in fuse mode)
# @param device     Directory to mount on the server
# @param mountpoint Local mount point
# @param user       Name of RADOS user
# @param key        Name of the secret key file inside the keys directory
# @param mode       Kernel or FUSE mode (default: 'kernel')
define ceph::posix::mount (
  $servers    = undef,
  $key        = undef,
  $device     = '/',
  $mountpoint = '/mnt',
  $user       = 'admin',
  $mode       = 'kernel',
  $ceph_file  = '/etc/ceph/ceph.conf',
){

  if $mode == 'kernel' {
    validate_string($key)
    validate_array($servers)
    $_keyfile = "${::ceph::posix::client::keys_dir}/${key}.key"

    $_device = sprintf("%s:%s", join($servers, ','), $device)
    $_options = sprintf("name=%s,secretfile=%s,_netdev", $user, $_keyfile)
    $_fstype = 'ceph'
    $_remounts = true

  } else {
    if $servers {
      warning("Servers supplied in FUSE mode will be ignored (configured by ${ceph_file}).")
    }

    $_device = "id=${user},client_mountpoint=${device}"
    $_options = '_netdev'
    $_fstype = 'fuse.ceph'
    $_remounts = false
  }

  file { $mountpoint:
    ensure => directory,
  }

  mount { $mountpoint:
    ensure   => mounted,
    fstype   => $_fstype,
    device   => $_device,
    options  => $_options,
    remounts => $_remounts,
    require  => File[$mountpoint],
  }
}
