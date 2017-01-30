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

class aufs::params {
  #### Module variables
  $service_name    = 'aufs-remote'
  $service_ensure  = running
  $service_enable  = true

  $packages = [ 'aufs-tools' ]
  $packages_ensure = 'installed'

  $script_file = '/usr/local/sbin/mount-aufs-remote'

  $overlay_dir  = '/lib/live/mount/overlay'

  $service_file = "/etc/systemd/system/${service_name}.service"
  $service_options_defaults = {
    'Unit'    => {
      'Description' => 'Mount remote parts of the aufs system',
      'After'       => 'remote-fs.target network-online.target',
    },
    'Service' => {
      'Type'            => 'simple',
      'RemainAfterExit' => 'yes',
      'ExecStart'       => $script_file,
    },
    'Install' => {
      'WantedBy'    => 'multi-user.target',
    },
  }

}
