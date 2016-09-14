require 'hiera'
require 'facter/network'

options = {
  :default => nil,
  :config => File.join(Hiera::Util.config_dir, 'puppet/hiera.yaml'),
  :scope => {
    'environment' => Puppet[:environment],
    'cluster_name' => Facter.value(:cluster_name),
  },
  :key => nil,
  :verbose => false,
  :resolution_type => :priority
}

def get_role_index_for_name(hostname, prefix)
  #(prefix)(role)XYZ 
  if hostname =~ /^#{prefix}([a-z]+)([0-9])+$/
    return [$1, $2]
  else
    return ['default', '0']
  end
end

begin
  hiera = Hiera.new(:config => options[:config])
  rescue Exception => e
  if options[:verbose]
    raise
  else
    STDERR.puts "Failed to start Hiera: #{e.class}: #{e}"
    exit 1
  end
end

unless options[:verbose]
  Hiera.logger = "noop"
end

########################################

options[:key] = "cluster_prefix"
prefix = hiera.lookup(options[:key], options[:default], options[:scope], nil, options[:resolution_type])
Facter.debug("Cluster prefix is: #{prefix}")

hostlist = Facter.value('hostfile')

hosts_by_role = Hash.new
hostlist.each do |name, ip_addr|
  role, index = get_role_index_for_name(name, prefix)
  if role == 'default'
    next
  end
  if hosts_by_role.has_key?(role)
    hosts = hosts_by_role[role]
  else
    hosts = Array.new
  end
  hosts.push(name)
  hosts_by_role[role] = hosts
end


myrole, myindex = get_role_index_for_name(Facter.value(:hostname), prefix)

Facter.add('puppet_role') do
  setcode do
    myrole
  end
end

Facter.add('puppet_index') do
  setcode do
    myindex
  end
end

Facter.add('hosts_by_role') do
  setcode do
    hosts_by_role
  end
end
