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

# This profile defines Virtual IP addresses associated with the role as a
# whole and not specific to a service.
# Virtual IP Addresses should be defined in hiera by following the hpc_ha
# module vip resource syntax.

class profiles::ha::role_vips {
  include ::hpc_ha

  $vips = hiera_hash("profiles::ha::role_vips", {})
  create_resources(hpc_ha::vip, $vips)

  $vservs = hiera_hash("profiles::ha::role_vservs", {})
  create_resources(hpc_ha::vserv, $vservs)
}

