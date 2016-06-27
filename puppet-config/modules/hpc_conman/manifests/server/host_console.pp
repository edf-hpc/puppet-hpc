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

define hpc_conman::server::host_console (
  $type,
  $console_prefix,
  $console_port   = undef,
){
  validate_string($console_prefix)

  case $type {
    'ipmi': {
      ::conman::console_ipmi { $name:
        host => "${console_prefix}${name}"
      }
    }
    'telnet': {
      validate_integer($console_port)
      ::conman::console_telnet { $name:
        host => "${console_prefix}${name}",
        port => $console_port,
      }
    }
    default: {
      fail("Unknown host console type: ${type}")
    }
  }
}
