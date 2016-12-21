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

class aufs::install inherits aufs {
  package { $::aufs::packages :
    ensure  => $::aufs::packages_ensure,
  }

  file { $::aufs::script_file :
    source => 'puppet:///modules/aufs/mount-aufs-remote',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  hpclib::systemd_service { $::aufs::service_name:
    target => $::aufs::service_file,
    config => $::aufs::_service_options,
  }
}
