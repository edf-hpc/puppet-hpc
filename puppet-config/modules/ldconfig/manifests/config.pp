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

class ldconfig::config inherits ldconfig {
  hpclib::print_config { '/etc/ld.so.conf.d/puppet_ldconfig.conf':
    style  => 'linebyline',
    data   => $::ldconfig::ldconfig_directories,
    notify => Exec['ldconfig_refresh'],
  }

  exec { 'ldconfig_refresh':
    command     => '/sbin/ldconfig',
    refreshonly => true,
  }

}

