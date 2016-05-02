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

define hpc_conmanserver::role_consoles (
  $type,
  $console_prefix,
  $console_port   = undef,
) {
  validate_string($type)
  validate_string($prefix)

  if $console_port {
    validate_integer($console_port)
  }

  $hosts = $hosts_by_role[$name]

  if $hosts {
    ::hpc_conmanserver::host_console { $hosts:
      type           => $type,
      console_prefix => $console_prefix,
      console_port   => $console_port,
    }
  } 
}
