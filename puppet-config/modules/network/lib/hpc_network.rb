#!/usr/bin/env ruby
##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2017 EDF S.A.                                           #
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


# An implicit interface is an interface not explicitely declared in the
# master_network hash for the host but exists because it is the member
# of a bond or of a bridge.
def hpc_network_implicit_ifaces(net_ifaces, bonding_options, bridge_options)
  implicit_ifaces = Hash.new
  sub_implicit_ifaces = Hash.new

  net_ifaces.each do |key, iface|
    if bonding_options.has_key?(iface['target'])
      bonding_options[iface['target']]['slaves'].each do |slave|
        implicit_ifaces[slave] = {'target' => slave}
      end
    end
    if bridge_options.has_key?(iface['target'])
      bridge_options[iface['target']]['ports'].each do |port|
        implicit_ifaces[port] = {'target' => port}
      end
    end
  end
  # Searching implicit interfaces recursively (bridge of bond interface)
  if not implicit_ifaces.empty?
    sub_implicit_ifaces = hpc_network_implicit_ifaces(implicit_ifaces, bonding_options, bridge_options)
  end
  return implicit_ifaces.merge(sub_implicit_ifaces)
end
