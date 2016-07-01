def hpc_shorewall_interfaces()
  # Retrieve facts
  #  HPC cluster networks
  topo = function_hiera(['net_topology'])
  #  Networks connected to this host
  mytopo = lookupvar('mynet_topology')

  interfaces = Hash.new()
  mytopo.each do |net_name, mynet|
    if not topo[net_name].has_key?('firewall_zone')
      next
    end
    mynet['interfaces'].each do |interface_name|
      interface = Hash.new()
      interface['zone'] =  topo[net_name]['firewall_zone']
      interfaces[interface_name] = interface
    end
  end
  
  return interfaces

end

# @return A hash with interfaces has key and a hash `{ 'zone' => '<firewall_zone'}` as value
Puppet::Parser::Functions::newfunction(
  :hpc_shorewall_interfaces, 
  :type  => :rvalue, 
  :arity => 0, 
  :doc   =>
    "Returns an array of shorewall interfaces for this host, based on the current network config. Interfaces are defined with the attribute firewall_zone in the cluster net_topology hiera."
) do |args|

  result = hpc_shorewall_interfaces()

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


