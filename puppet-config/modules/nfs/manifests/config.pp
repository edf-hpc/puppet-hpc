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

class nfs::config inherits nfs {

  hpclib::print_config { $::nfs::idmapd_file :
    style    => 'ini',
    comments => ';',
    data     => $::nfs::_idmapd_options,
    notify   => Service[$::nfs::service],
  }

  hpclib::print_config { $::nfs::default_file :
    style    => 'keyval',
    comments => '#',
    data     => $::nfs::_default_options,
    notify   => Service[$::nfs::service],
  }

}
