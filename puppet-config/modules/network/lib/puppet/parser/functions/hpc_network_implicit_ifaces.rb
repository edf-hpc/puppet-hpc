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

require('hpc_network')

# @param arg1 net_ifaces, structure with the master/bridge interfaces
# @param arg2 bonding_options, the bonding_options passed to the
#             network class
# @param arg3 bridge_options, the bridge_options passed to the
#             network class
# @return net_ifaces like structure with the slave devices
Puppet::Parser::Functions::newfunction(
  :hpc_network_implicit_ifaces,
  :type  => :rvalue,
  :arity => 3,
  :doc   =>
    "Find all the relevant ifaces that are slave of bond interface"
) do |args|
  net_ifaces = args[0]
  bonding_options = args[1]
  bridge_options = args[2]

  result = hpc_network_implicit_ifaces(net_ifaces, bonding_options, bridge_options)

  begin
    result
  rescue Puppet::ParseError => internal_error
    if internal_error.original.nil?
      raise internal_error
    else
      raise internal_error.original
    end
  end
end
