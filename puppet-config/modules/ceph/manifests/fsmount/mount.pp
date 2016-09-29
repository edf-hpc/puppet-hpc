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

class ceph::fsmount::mount inherits ceph::fsmount {

  if $::ceph::fsmount::mount_manage {

    mount { $::ceph::fsmount::mount_point:
      ensure  => mounted,
      fstype  => 'ceph',
      device  => $::ceph::fsmount::_device,
      options => $::ceph::fsmount::_options,
    }

  }
}
