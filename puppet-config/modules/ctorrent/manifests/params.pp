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

class ctorrent::params {

#### Module variables

  $packages_ensure = 'latest'
  $packages        = ['ctorrent']
  $default_file    = '/etc/default/ctorrent'
  $service         = 'ctorrent' 

#### Defaults values
  $init_file        = '/etc/init.d/ctorrent'
  $ctorrent_options = {
    delay        => '-1',
    misc_options => '-f',
    clusters     => {
      "${cluster}" => {
        "${system}" => {
          torrent_file => "${tracker_path}/${system}/${system}.squashfs.torrent",
          seeded_file  => "${tracker_path}/${system}/${system}.squashfs",
        },
      }
    }
  }


}
