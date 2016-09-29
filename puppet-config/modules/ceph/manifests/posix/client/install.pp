##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

class ceph::posix::client::install inherits ceph::posix::client {

  file { $::ceph::posix::client::keys_dir:
    ensure => directory,
    owner  => $::ceph::posix::client::key_owner,
    group  => $::ceph::posix::client::key_group,
    mode   => 0755,
  }

  if $::ceph::posix::client::packages_manage {
    package { $::ceph::posix::client::packages:
      ensure => $::ceph::posix::client::packages_ensure,
    }
  }
}
