require 'hpc/nodeset'

Puppet::Parser::Functions::newfunction(
  :hpc_nodeset_expand, 
  :type  => :rvalue, 
  :arity => 1, 
  :doc   =>
    "Returns an array of node name corresponding to the expanded nodeset expression."
) do |args|

  nodeset = args[0]
  result = hpc_nodeset_expand(nodeset)

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


