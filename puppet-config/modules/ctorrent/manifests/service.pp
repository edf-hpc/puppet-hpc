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

class ctorrent::service inherits ctorrent {

  service { $service :
    ensure  => running,
    enable  => true,
    require => [Package[$packages],File[$default_file,$init_file]],
  }
 
  cron { $init_file :
    command    => "PATH=\$PATH:/sbin; systemctl restart ${service}.service &> /dev/null || exit 0",
    user       => 'root',
    require    => File[$init_file],
  }
}
