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

# Activate HA for roles
#
# /!\ This profile is probably broken with changes coming with new profile
# ha::base. Do not use it.
#
# This profile defines Virtual IP addresses associated with the role as a
# whole and not specific to a service.
# Virtual IP Addresses should be defined in hiera by following the hpc_ha
# module vip resource syntax.
# This profile describes HA configuration that are applied to all machine
# of the same role. This is done by configuring two hiera hashes:
#
# * for the virtual IP addresses (failover):
#
# ```
# #### High-Availability Virtual IP addresses ######
# profiles::ha::role_vips:
#   administration_misc:
#     prefix:      "%{hiera('cluster_prefix')}"
#     net_id:      'administration'
#     router_id:   '121'
#     ip_address:  '10.100.2.20'
#     auth_secret: 'SECRET'
#   wan_misc:
#     prefix:      "%{hiera('cluster_prefix')}"
#     net_id:      'wan'
#     router_id:   '122'
#     ip_address:  '192.168.42.55'
#     auth_secret: 'SECRET'
# ```
#
# * One for the virtual servers (load balancing):
#
# ```
# profiles::ha::role_vservs:
#   wan_front_ssh:
#     ip_address:        '192.168.42.57'
#     port:              '22'
#     vip_name:          'wan_front'
#     real_server_hosts:
#       - 'extgenfront1'
# ```
#
# ## Hiera
# * `profiles::ha::role_vips` (`hiera_hash`)
# * `profiles::ha::role_vservs` (`hiera_hash`)
class profiles::ha::role {
  include ::hpc_ha

  $vips = hiera_hash("profiles::ha::role_vips", {})
  create_resources(hpc_ha::vip, $vips)

  $vservs = hiera_hash("profiles::ha::role_vservs", {})
  create_resources(hpc_ha::vserv, $vservs)
}

