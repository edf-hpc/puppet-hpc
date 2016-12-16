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

# Activate HA

class profiles::ha::base {

  $vips = hpc_ha_vips()
  $vip_notify_scripts = hpc_ha_vip_notify_scripts()
  $vservs = hpc_ha_vservs()

  class { '::hpc_ha':
    vips               => $vips,
    vip_notify_scripts => $vip_notify_scripts,
    vservs             => $vservs,
  }

  Network::Print_config <||> ~> Service <| tag == 'keepalived' |>
}
