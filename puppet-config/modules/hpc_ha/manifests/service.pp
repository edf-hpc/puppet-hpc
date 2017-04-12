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

class hpc_ha::service inherits hpc_ha {

  # service_manage == false just means the keepalived community module does not
  # manage the service resource. In this case, the hpc_ha module just ensures
  # the systemd unit has the expected state.
  unless $::hpc_ha::service_manage {
    systemd::unit_state { 'keepalived':
      state => $::hpc_ha::service_state,
    }
  }

}
