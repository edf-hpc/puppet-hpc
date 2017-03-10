#!/usr/bin/env ruby
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

require('hpc/nodeset')

def hpc_roles_single_nodeset(roles = nil)
  # Retrieve facts 
  hosts_by_role = lookupvar('hosts_by_role')

  if not roles 
    roles = hosts_by_role.keys()
  end

  nodes = Array.new()
  roles.each do |role|
    if not hosts_by_role.has_key?(role)
      debug "Role #{role} has no host"
      next
    end
    role_nodes = hosts_by_role[role]
    nodes = nodes + role_nodes
  end
  
  return hpc_nodeset_fold(nodes)
end

# @return A nodeset expression with all the hosts having selected roles
# @param roles A list of roles to select, if nil, all roles are selected
Puppet::Parser::Functions::newfunction(
  :hpc_roles_single_nodeset, 
  :type  => :rvalue, 
  :arity => -1, 
  :doc   =>
    "Return a single nodeset of all the hosts in the roles passed as argument"
) do |args|

  if args.length > 0
    roles = args[0]
  else
    roles = nil
  end
  result = hpc_roles_single_nodeset(roles)

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


