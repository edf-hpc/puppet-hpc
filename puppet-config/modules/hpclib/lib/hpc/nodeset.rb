# This class defines methods to handle clustershell style nodesets
# it is currently implemented as direct call to the "nodeset" tool
# from clustershell. 
#
# This should be replaced with a pure ruby implementation.

require('open3')

NODESET_BIN='/usr/bin/nodeset'

def hpc_nodeset_exec(params)
  if not File.executable?(NODESET_BIN)
    raise "Nodeset check_bin failed, #{NODESET_BIN} is not executable."
  end
  command = "#{NODESET_BIN} #{params}"
  out, err, status = Open3.capture3(command)
  if status.exitstatus != 0
    raise "Nodeset call with params(#{params}) failed with " +
      "status (#{status.exitstatus}). Error:\n" + err
  end
  return out
end

def hpc_nodeset_fold(nodes_array)
  if not nodes_array.kind_of?(Array)
    raise "Parameter nodes_array should be an array."
  end
  if nodes_array.length == 0
    return ""
  end
  nodes_list = nodes_array.join(' ')
  nodeset = hpc_nodeset_exec("-f #{nodes_list}")
  return nodeset.strip()
end

def hpc_nodeset_expand(nodeset)
  if nodeset == ""
    return Array.new()
  end
  output = hpc_nodeset_exec("-e #{nodeset}")
  return output.strip().split(' ')
end
