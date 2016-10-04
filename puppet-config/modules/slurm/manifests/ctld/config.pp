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

class slurm::ctld::config inherits slurm::ctld {

  if $::slurm::ctld::config_manage {

    if $::slurm::ctld::enable_topology {
      hpclib::print_config { $::slurm::ctld::topology_file:
        style => 'linebyline',
        data  => $::slurm::ctld::topology_options,
      }
    }

    if $::slurm::ctld::enable_lua {
      file { $::slurm::ctld::submit_lua_file:
        source => $::slurm::ctld::submit_lua_source,
      }

      hpclib::print_config { $::slurm::ctld::submit_lua_conf:
        style    => 'keyval',
        comments => '--',
        data     => $::slurm::ctld::_submit_lua_options,
      }

      exec { 'gen-qos-conf':
        command => $::slurm::ctld::submit_qos_exec,
        creates => $::slurm::ctld::submit_qos_conf,
      }
    }

    if $::slurm::ctld::enable_wckeys {
      # Work in progress
    }

  }
}
