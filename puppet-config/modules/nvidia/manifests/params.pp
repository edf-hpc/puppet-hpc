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

class nvidia::params {
  $packages = [
    'nvidia-driver'
  ]
  $packages_ensure = 'installed'

  $device_uid_num = '0'
  # video on debian
  $device_gid_num = '44'
  $device_file_mode = '0660'

  $modprobe_file = '/etc/modprobe.d/nvidia-kernel-common.conf'
}

