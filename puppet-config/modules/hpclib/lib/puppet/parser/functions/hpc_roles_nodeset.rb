require('hpc/nodeset')

def hpc_roles_nodeset(roles = nil)
  # Retrieve facts 
  hosts_by_role = lookupvar('hosts_by_role')

  if not roles 
    roles = hosts_by_role.keys()
  end

  nodesets = Hash.new()
  roles.each do |role|
    if not hosts_by_role.has_key?(role)
      debug "Role #{role} has no host"
      next
    end
    nodeset = hpc_nodeset_fold(hosts_by_role[role])
    nodesets[role] = nodeset
  end
  
  return nodesets
end

# @return A hash with role names as keys and nodeset expression as value
# @param roles Array of roles to return, if nil, all roles are returnes
Puppet::Parser::Functions::newfunction(
  :hpc_roles_nodeset, 
  :type  => :rvalue, 
  :arity => -1, 
  :doc   =>
    "Return a hash of roles and nodeset for roles passed as argument"
) do |args|

  if args.length > 0
    roles = args[0]
  else
    roles = nil
  end
  result = hpc_roles_nodeset(roles)

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


