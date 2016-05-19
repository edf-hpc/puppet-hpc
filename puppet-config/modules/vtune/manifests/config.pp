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

class vtune::config inherits vtune {

  hpclib::print_config { $default_file :
    style   => 'keyval',
    data    => $default_options,
    require => Package[$packages],
  }

  exec { 'vtune_load' :
    command => '/usr/sbin/vtune-modules load',
    unless  => "lsmod | cut -d ' ' -f 1 | grep -q -E 'pax|sep|vtsspp'",
    path    => ['/usr/bin','/sbin','/bin','/usr/sbin','/usr/local/sbin'],
    require => Hpclib::Print_config[$default_file],
  }
}
