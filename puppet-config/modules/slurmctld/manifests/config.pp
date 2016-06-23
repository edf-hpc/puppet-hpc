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

class slurmctld::config {

  if $slurmctld::config_manage {

    require slurmcommons

    if $slurmctld::enable_topology {

      hpclib::print_config { $slurmctld::topo_conf_file :
        style => 'linebyline',
        data  => $slurmctld::topology_conf,
      }
    }
    if $slurmctld::enable_lua {

      file { $slurmctld::submit_lua_script :
        source => $slurmctld::submit_lua_source,
      }
    }

    if $slurmctld::enable_wckeys {

    # Work in progress

    }
  }
}
