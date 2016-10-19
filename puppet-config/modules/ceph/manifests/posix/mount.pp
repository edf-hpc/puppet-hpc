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

# Mount a POSIX Ceph FS using kernel module
#
# @param servers    Array of Ceph MON servers
# @param device     Directory to mount on the server
# @param mountpoint Local mount point
# @param user       Name of RADOS user
# @param key        Name of the secret key file inside the keys directory
define ceph::posix::mount (
  $servers    = [ 'localhost' ],
  $device     = '/',
  $mountpoint = '/mnt',
  $user       = 'admin',
  $key,
){

  $_keyfile = "${::ceph::posix::client::keys_dir}/${key}.key"

  $_device = sprintf("%s:%s", join($servers, ','), $device)
  $_options = sprintf("name=%s,secretfile=%s,_netdev", $user, $_keyfile)

  file { $mountpoint:
    ensure => directory,
  }

  mount { $mountpoint:
    ensure  => mounted,
    fstype  => 'ceph',
    device  => $_device,
    options => $_options,
    require => File[$mountpoint],
  }

}
