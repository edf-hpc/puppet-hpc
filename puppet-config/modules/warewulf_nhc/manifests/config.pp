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

class warewulf_nhc::config inherits warewulf_nhc {

  file { $::warewulf_nhc::config_file :
    content => template('warewulf_nhc/nhc_conf.erb'),
    mode    => '0600',
    require => Package[$::warewulf_nhc::packages],
  }

  hpclib::print_config { $::warewulf_nhc::default_file :
    style   => 'keyval',
    data    => $::warewulf_nhc::default_options,
    mode    => '0600',
    require => Package[$::warewulf_nhc::packages],
  }

}
