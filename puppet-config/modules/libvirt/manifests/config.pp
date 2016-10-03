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

class libvirt::config inherits libvirt {

  hpclib::print_config { $::libvirt::config_file :
    style  => 'keyval',
    data   => $::libvirt::_config_options,
    notify => Class['::libvirt::service'],
  }

  Libvirt::Secret <| |> ->
  Libvirt::Pool <| |>
  Libvirt::Network <| |>
}
