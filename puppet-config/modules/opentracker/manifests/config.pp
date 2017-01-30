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

class opentracker::config inherits opentracker {

  hpclib::print_config { $::opentracker::default_file :
    style  => 'keyval',
    target => $::opentracker::default_file,
    data   => $::opentracker::opentracker_default_options,
  }

  file { $::opentracker::config_dir :
    ensure => directory,
  }

  file { $::opentracker::config_file :
    ensure  => present,
    content => template('opentracker/opentracker_conf.erb'),
    path    => "${::opentracker::config_dir}/${::opentracker::config_file}",
    require => [
      Package[$::opentracker::packages],
      File[$::opentracker::config_dir]
    ],
  }

  hpclib::systemd_service { $::opentracker::systemd_service_file :
    target => $::opentracker::systemd_service_file,
    config => $::opentracker::systemd_service_file_options,
  }

}
