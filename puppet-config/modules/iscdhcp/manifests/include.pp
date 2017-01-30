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

# File declaring a subnet pool included in the configuration
#
# An include file contains the actual MAC => IP address mapping.
#
# @param pool_name Name of the pool
# @param subnet_name Name of the subnet
# @param tftp Set filename parameter on these hosts
# @param pool Hash with options for this pool
# @param my_address IP address of this host for next-server parameter
# @param bootmenu_url URL to set as filename for iPXE requests
# @param ipxebin DEPRECATED
# @param dhcp_config Hash giving the host, IP address, MAC address association
define iscdhcp::include (
  $pool_name,
  $subnet_name,
  $tftp,
  $pool,
  $my_address,
  $bootmenu_url,
  $ipxebin,
  $dhcp_config,
) {

  file { $pool['include'] :
    content => template('iscdhcp/dhcp.conf.include.erb'),
  }

}
