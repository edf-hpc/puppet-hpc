###### Initialize Hiera backend #######
require 'hiera'
require 'facter/application'
require 'facter/osfamily'
require 'facter/util/ip'
require 'facter/util/macaddress'
require 'ipaddr'

options = {
  :default => nil,
  :config  => File.join(Hiera::Util.config_dir, 'puppet/hiera.yaml'),
  :scope => {
    'environment' => Puppet[:environment],
  },
  :key     => nil,
  :verbose => false,
  :resolution_type => :priority
}

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

#########################################

### Define variables ###
eth_hwaddr = Facter.value(:macaddress)
h_name = Facter.value(:hostname)
os = Facter.value(:osfamily)
mymasternet = nil
hostfile = Hash.new 
netconfig = Hash.new
dhcpconfig = Hash.new
ifaces_target = Hash.new
ifaces_target = { 'eth0' => {'target' => 'eth0'}}
mynet_topology = Hash.new
options[:key] = "master_network"
masternetwork = hiera.lookup(options[:key], options[:default], options[:scope], nil, options[:resolution_type])

options[:key] = 'net_topology'
net_topology = hiera.lookup(
  options[:key],
  options[:default],
  options[:scope],
  nil,
  options[:resolution_type]
)


### Begin parsing ###
if !masternetwork.nil? and masternetwork.length > 0
  ### Set mymasternet used to generate local network config ###
  if ( eth_hwaddr.length > 0 and masternetwork[h_name]['networks']['administration']['DHCP_MAC'].match(/\b#{eth_hwaddr}\b/i) ) or ( h_name.length > 0 and masternetwork[h_name]['networks']['administration']['hostname'].match(/[;,]#{h_name}[;,]/) )
    mymasternet = masternetwork[h_name]
  end
  ### Begin parsing ###
  masternetwork.each do | machine,params|
    networks = params['networks']
    networks.each do |n_name,n_params|
      hname   = n_params['hostname']
      macaddr = n_params['DHCP_MAC'].to_s
      ipaddr  = n_params['IP'].to_s
      #### Set dhcpconfig used to generate dhcpd config files and /etc/hosts ###
      #### Structure: {"hostname"=>{"macaddress"=>"00:00:00:00:00:AA", "ipaddress"=>"10.0.0.1"}} ###
      if ( macaddr.length > 0 ) 
        dhcpconfig[hname] = Hash.new
        dhcpconfig[hname]["macaddress"] = macaddr
        dhcpconfig[hname]['ipaddress']  = ipaddr
      end
      #### Set hostfile used to generate /etc/hosts file (may differ from dhcp configuration) ###
      #### Structure: {"hostname"=>"10.0.0.1"} ###
      hostfile[hname] = ipaddr
    end
  end
### End parsing ###

  if not mymasternet
    raise "Could not find an entry for this node in master_network hiera array (no matching name or MAC address)"
  end

  mymasternet['networks'].each do |network,params|
    iface   = params['device']
    address = params['IP']
    nmask   = net_topology[network]['netmask']
    ### Build netconfig (iface -> Address)                   ###
    ### Structure: {"interface"=>["10.0.0.1/255.255.255.0"]} ###
    if not params['external_config']
      if iface
        if not netconfig.has_key?(iface)
          netconfig[iface] = Array.new
        end
        netconfig[iface].push(address+"/"+nmask)
        ifaces_target[iface] = {'target' => iface} if os == 'Redhat'
      end
    end
    ### Build mynet_topology (net name -> iface association)
    ### Structure: {
    ###               "net_id"=> {
    ###                 interfaces      => ["interface","interface"],
    ###                 name            => "name"
    ###                 firewall_zone   => "firewall_zone"
    ###                 external_config => true/false
    ###               }
    ###            }
    ### multiple interfaces on the same net_id should be rare
    if iface
    mynet_topology[network] = Hash.new
      if not mynet_topology[network].has_key?('interfaces')
          mynet_topology[network]['interfaces'] = Array.new
      end
      mynet_topology[network]['interfaces'].push(iface) 
      mynet_topology[network]['name']          = net_topology[network]['name']
      mynet_topology[network]['firewall_zone'] = net_topology[network]['firewall_zone']
      if params['external_config']
        mynet_topology[network]['external_config'] = params['external_config']
      else
        mynet_topology[network]['external_config'] = false
      end
    end
  end
end
### Add facters ###
Facter.add(:netconfig) do
  setcode do
    netconfig
  end
end

Facter.add(:dhcpconfig) do
  setcode do
    dhcpconfig
  end
end

Facter.add(:hostfile) do
  setcode do
    hostfile
  end
end

Facter.add(:ifaces_target) do
  setcode do
    ifaces_target
  end
end

Facter.add(:mymasternet) do
  setcode do
    mymasternet
  end
end

Facter.add(:mynet_topology) do
  setcode do
    mynet_topology
  end
end
