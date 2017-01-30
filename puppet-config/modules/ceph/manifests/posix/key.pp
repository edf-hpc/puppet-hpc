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

# Mount a POSIX Ceph FS using kernel module
#
# @param key        The secret key file
define ceph::posix::key (
  $key
)
{
    $_keyfile = "${::ceph::posix::client::keys_dir}/${name}.key"

    file { $_keyfile:
      content => $key,
      owner   => $::ceph::posix::client::keys_owner,
      group   => $::ceph::posix::client::keys_group,
      mode    => $::ceph::posix::client::keys_mode,
    }

}
