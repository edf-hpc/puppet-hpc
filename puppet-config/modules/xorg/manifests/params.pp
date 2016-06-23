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

class xorg::params {
  $service = 'xorg'
  $service_ensure = 'running'
  $service_enable = true
  $service_file = "/etc/systemd/system/${service}.service"
  $service_options_defaults = {
    'Unit'    => {
      'Description' => 'Standalone X.org server (no display manager)',
      'After'       => 'local-fs.target',
    },
    'Service' => {
      'Type'        => 'simple',
      'ExecStart'   => '/usr/bin/Xorg',
    },
    'Install' => {
      'WantedBy'    => 'multi-user.target',
    },
  }

  $packages = [
    'xserver-xorg'
  ]
  $packages_ensure = 'installed'

  $config_file = '/etc/X11/xorg.conf'

  $bus_id = 'auto'
  # auto, nvidia
  $driver = 'auto'
}

