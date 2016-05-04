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

class sssd::config inherits sssd {

  file { $config_dir :
    ensure => directory,
  }

  hpclib::print_config { $config_file :
    style   => 'ini',
    data    => $sssd_options,
    mode    => 0600,
    require => [Package[$packages],File[$config_dir]],
    notify  => Service[$service],
  }

  hpclib::print_config { $default_file :
    style   => 'keyval',
    data    => $default_options,
    require => Package[$packages],
    notify  => Service[$service],
  }

}
