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

# Configures a NFS HA server.
#
# Please note that this profile conflicts with the  profiles::ha::base profile
# as they both instanciate the hpc_ha module. Both profiles cannot be used
# simultaneously on the same role.
class profiles::nfs::ha_server {
  $vips = hpc_ha_vips()

  # On NFS HA servers, the keepalived service is managed manually by the admins.
  # It is not desired that Puppet nor the system (at boot time) start the
  # service automatically. To ensure this, the hpc_ha module is told to not
  # manage the service (ie. not check its current state and act), just ensure it
  # is disabled at boot time.

  class { '::hpc_ha':
    vips           => $vips,
    service_manage => false,
    service_state  => 'disabled',
  }
  include ::hpc_nfs::ha_server

}
