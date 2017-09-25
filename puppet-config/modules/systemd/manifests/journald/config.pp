##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016-2017 EDF S.A.                                      #
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

class systemd::journald::config inherits ::systemd::journald {

  if $::systemd::journald::config_manage {
    $defaults_journald = { 'component' => 'journald' }
    create_resources( systemd::component::param,
                      $::systemd::journald::_config_options,
          $defaults_journald)
  }
}
