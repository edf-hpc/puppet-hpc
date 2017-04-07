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

class hpcconfig::push::config inherits hpcconfig::push {

  hpclib::print_config { $::hpcconfig::push::config_file:
    style => 'ini',
    data  => $::hpcconfig::push::_config_options,
    mode  => 0600,
  }

  hpclib::print_config { $::hpcconfig::push::eyaml_config_file:
    style => 'yaml',
    data  => $::hpcconfig::push::eyaml_config_options,
  }

}
