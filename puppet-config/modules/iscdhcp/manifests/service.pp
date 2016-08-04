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

#
class iscdhcp::service inherits iscdhcp {

  hpclib::systemd_service { $iscdhcp::systemd_config_file :
    target => $iscdhcp::systemd_config_file,
    config => $iscdhcp::systemd_config_options,
  }

  service { $iscdhcp::service :
    require   => Package[$iscdhcp::packages],
    subscribe => [
      File[$iscdhcp::default_file],
      Concat[$iscdhcp::config_file],
    ],
  }

}
