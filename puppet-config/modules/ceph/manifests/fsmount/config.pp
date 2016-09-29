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

class ceph::fsmount::config inherits ceph::fsmount {

  if $::ceph::fsmount::config_manage {

    file { $::ceph::fsmount::_key_dir:
      ensure => directory,
      owner  => $::ceph::fsmount::key_owner,
      group  => $::ceph::fsmount::key_group,
      mode   => 0755,
    }

    file { $::ceph::fsmount::key_file:
      content => $::ceph::fsmount::key,
      owner   => $::ceph::fsmount::key_owner,
      group   => $::ceph::fsmount::key_group,
      mode    => $::ceph::fsmount::key_mode,
      require => File[$::ceph::fsmount::_key_dir],
    }

  }
}
