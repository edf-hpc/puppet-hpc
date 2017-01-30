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

class openmpi::config inherits openmpi {

  hpclib::print_config { $::openmpi::device_config['path'] :
    style => $::openmpi::device_config['style'],
    data  => $::openmpi::device_config['data'],
  }

  hpclib::print_config { $::openmpi::default_config['path'] :
    style => $::openmpi::default_config['style'],
    data  => $::openmpi::default_config['data'],
  }

}
