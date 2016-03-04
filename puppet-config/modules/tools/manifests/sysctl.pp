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

define tools::sysctl($config, $sysctlfile) {

  $rootdir = '/etc/sysctl.d'
  $tpl = 'tools/sysctl.erb'
  $sysctlcmd = 'sysctl'

  file { $rootdir :
    ensure     => 'directory',
  }

  tools::print_config { $sysctlfile :
    style   => 'keyval',
    target  => "${rootdir}/${sysctlfile}",
    params  => $config,
    require => File[$rootdir],
  }

  exec { "${sysctlcmd}_${sysctlfile}" :
    command   => "${sysctlcmd} -p ${rootdir}/${sysctlfile}",
    subscribe => File["${rootdir}/${sysctlfile}"],
    path      => ['/bin','/sbin'],
  }
}

