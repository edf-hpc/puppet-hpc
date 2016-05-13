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


