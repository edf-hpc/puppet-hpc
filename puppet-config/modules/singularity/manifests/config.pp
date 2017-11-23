##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2017 EDF S.A.                                           #
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

class singularity::config inherits singularity {

  if $::singularity::config_options != [] {
    hpclib::print_config{ $::singularity::config_file:
      style => 'linebyline',
      data  => $::singularity::config_options,
    }
  }

  if $::singularity::envinit_manage {
    hpclib::hpc_file{ $::singularity::envinit_file:
      source => $::singularity::envinit_source,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

}

