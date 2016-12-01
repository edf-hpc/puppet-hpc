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


# A conman host console
#
# Add a console of the given type for the host given as a resource name.
# The console device hostname is made of a prefix and the hostname:
# ```
#   hpc_conman::server::host_console { 'clcn001':
#     type   => 'ipmi',
#     prefix => 'bmc',
#   }
# ```
#
# This will create a console with the hostname `bmcclcn001`.
#
# @param title The hostname of the machine
# @param type Console type, `ipmi` or `telnet`
# @param console_prefix String to prefix to the hostname to get the console
#           device hostname.
# @param console_port Port to use on the console device
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
