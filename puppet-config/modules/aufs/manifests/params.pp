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

class aufs::params {
  #### Module variables
  $service         = 'aufs'
  $service_ensure  = running
  $service_enable  = true

  $branch_name = hiera('profiles::environment::userspace::aufs_branch')
  $service_file = "/etc/systemd/system/${service}.service"
  $service_options_defaults = {
    'Unit'    => {
      'Description' => 'Appends an additional branch into loaded aufs',
      'After'       => 'remote-fs.target network.target',
    },
    'Service' => {
      'Type'         => 'oneshot',
      'ExecStartPre' => "/usr/bin/stat $branch_name",
      'RestartSec'   => '5s',
      'RemainAfterExit' => 'yes',
      'ExecStart'    => "/bin/sh -c \"grep -q '$branch_name' /sys/fs/aufs/si_*/br* || mount -t aufs -o remount,append:$branch_name none /\"",
      'ExecStop'     => "/bin/sh -c \"grep -v -q '$branch_name' /sys/fs/aufs/si_*/br* || mount -t aufs -o remount,del:$branch_name none /\"",
    },
    'Install' => {
      'WantedBy'    => 'multi-user.target',
    },
  }

}
