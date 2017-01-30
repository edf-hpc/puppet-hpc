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

define conman::console_telnet (
  $host,
  $port
) {
  validate_string($host)
  validate_integer($port)

  concat::fragment { "conman_config_console_telnet_${name}":
    target  => '/etc/conman.conf',
    content => "console name=\"${name}\" dev=\"${host}:${port}\"\n",
    order   => '11',
  }
}
