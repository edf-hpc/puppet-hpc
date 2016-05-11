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

class opentracker::config inherits opentracker {

  hpclib::print_config { $default_file :
    style  => 'keyval',
    target => $default_file,
    data   => $opentracker_default_options,
  }

  file { $config_dir :
    ensure => directory,
  }

  file { $config_file :
    ensure  => present,
    content => template('opentracker/opentracker_conf.erb'),
    path    => "${config_dir}/${config_file}",
    require => [Package[$packages], File[$config_dir]],
  }

  hpclib::systemd_service { $systemd_service_file :
    target => $systemd_service_file,
    config => $systemd_service_file_options,
  }

}
