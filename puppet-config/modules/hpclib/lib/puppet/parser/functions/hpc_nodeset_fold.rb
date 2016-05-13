require 'hpc/nodeset'

Puppet::Parser::Functions::newfunction(
  :hpc_nodeset_fold, 
  :type  => :rvalue, 
  :arity => 1, 
  :doc   =>
    "Returns a nodeset expression corresponding to nodes in the array."
) do |args|

  nodes_array = args[0]
  result = hpc_nodeset_fold(nodes_array)

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


