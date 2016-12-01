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


# Create all consoles for a role
#
# This resource will create all `hpc_conman::server::host_console` for the
# machines having the role passed in the title of the resource.
#
# @param title The name of the role
# @param type Console type, `ipmi` or `telnet`
# @param console_prefix String to prefix to the hostname to get the console
#           device hostname.
# @param console_port Port to use on the console device
define hpc_conman::server::role_consoles (
  $type,
  $console_prefix,
  $console_port   = undef,
) {
  validate_string($type)
  validate_string($console_prefix)

  if $console_port {
    validate_integer($console_port)
  }

  $hosts = $::hosts_by_role[$name]

  if $hosts {
    ::hpc_conman::server::host_console { $hosts:
      type           => $type,
      console_prefix => $console_prefix,
      console_port   => $console_port,
    }
  }
}
