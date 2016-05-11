##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2015 EDF S.A.                                      #
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

define hpclib::sysctl($config, $sysctl_file) {

  $rootdir        = '/etc/sysctl.d'
  $sysctl_command = 'sysctl'

  file { $rootdir :
    ensure     => 'directory',
  }

  hpclib::print_config { $sysctl_file :
    style   => 'keyval',
    target  => "${rootdir}/${sysctl_file}",
    params  => $config,
    require => File[$rootdir],
  }

  exec { "${sysctl_command}_${sysctl_file}" :
    command     => "${sysctl_command} -p ${rootdir}/${sysctl_file}",
    subscribe   => File["${rootdir}/${sysctl_file}"],
    path        => ['/bin','/sbin'],
  }
}
