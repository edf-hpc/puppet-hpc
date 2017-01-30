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

class sssd::config inherits sssd {

  file { $::sssd::config_dir :
    ensure => directory,
  }

  hpclib::print_config { $::sssd::config_file :
    style   => 'ini',
    data    => $::sssd::sssd_options,
    mode    => '0600',
    require => [
      Package[$::sssd::packages],
      File[$::sssd::config_dir]
    ],
    notify  => Service[$::sssd::service],
  }

  hpclib::print_config { $::sssd::default_file :
    style   => 'keyval',
    data    => $::sssd::default_options,
    require => Package[$::sssd::packages],
    notify  => Service[$::sssd::service],
  }

}
