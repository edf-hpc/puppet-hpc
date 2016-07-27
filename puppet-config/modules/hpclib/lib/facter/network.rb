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
  masternetwork.each do | line|
    ### Set mymasternet used to generate local network config ###
    if ( eth_hwaddr.length > 0 and line.match(/\b#{eth_hwaddr}\b/i) ) or ( h_name.length > 0 and line.match(/#{h_name}/) )
        mymasternet = line.chomp.split(';')
    end
    element = line.split(";") 
    i = 0; macadds   = Array.new; macadds   = element[i].split(",") unless element[i].empty?
    i = 2; hnames    = Array.new; hnames    = element[i].split(",") unless element[i].empty?
    i = 3; addresses = Array.new; addresses = element[i].split(",") unless element[i].empty?
    i = 5; dhcpd     = Array.new; dhcpd     = element[i].split(",") unless element[i].empty?
    i = 7; hosts     = Array.new; hosts     = element[i].split(",") unless element[i].empty?
    #### Set dhcpconfig used to generate dhcpd config files and /etc/hosts ###
    #### Structure: {"hostname"=>{"macaddress"=>"00:00:00:00:00:AA", "ipaddress"=>"10.0.0.1"}} ###
    dhcpd.each do | triplet|
      index = triplet.split("@")
      mca = index[0].to_i; hnm = index[1].to_i; add = index[2].to_i;
      dhcpconfig[hnames[hnm]] = Hash.new 
      dhcpconfig[hnames[hnm]]['macaddress'] = macadds[mca]
      dhcpconfig[hnames[hnm]]['ipaddress'] = addresses[add]
    end
    #### Set hostfile used to generate /etc/hosts file (may differ from dhcp configuration) ###
    #### Structure: {"hostname"=>"10.0.0.1"} ###
    hosts.each do | duplet|
      index = duplet.split("@")
      hnm = index[0].to_i; add = index[1].to_i;
      hostfile[hnames[hnm]] = addresses[add]
    end
  end 
  ### End parsing ###

  if not mymasternet
    raise "Could not find an entry for this node in master_network hiera array (no matching name or MAC address)"
  end
  i = 1; ifaces    = Array.new; ifaces    = mymasternet[i].split(",") unless mymasternet[i].empty? 
  i = 3; addresses = Array.new; addresses = mymasternet[i].split(",") unless mymasternet[i].empty? 
  i = 4; netmasks  = Array.new; netmasks  = mymasternet[i].split(",") unless mymasternet[i].empty? 
  i = 6; netcfg    = Array.new; netcfg    = mymasternet[i].split(",") unless mymasternet[i].empty? 
  ### Set netconfig used to generate local network config and mynet_toplogy ###
  netcfg.each do | triplet| 
    index = triplet.split("@")
    iface   = ifaces[index[0].to_i]
    address = addresses[index[1].to_i]
    netmask = netmasks[index[2].to_i]

    ### Build netconfig (iface -> Address)                   ###
    ### Structure: {"interface"=>["10.0.0.1/255.255.255.0"]} ###
    if not netconfig.has_key?(iface)
      netconfig[iface] = Array.new
    end
    netconfig[iface].push(address+"/"+netmask)
    ifaces_target[iface] = {'target' => iface} if os == 'Redhat'

    ### Build mynet_topology (net name -> iface association)        ###
    ### Structure: {                                                ###
    ###               "net_id"=> {                                  ###
    ###                 interfaces    => ["interface","interface"], ###
    ###                 name          => "name"                     ###
    ###                 firewall_zone => "firewall_zone"            ###
    ###               }                                             ###
    ###            }                                                ###
    ### multiple interfaces on the same net_id should be rare       ###
    found_net = nil
    # Search the network where the address is in
    if !net_topology.nil? and masternetwork.length > 0
      net_topology.each do |net_id, net|
        if not net.has_key?('prefix_length')
          next
        end
        ip_net = IPAddr.new(net['ipnetwork'] + net['prefix_length'])
        if ip_net === address
          found_net = net_id
          break
        end
      end
      if found_net != nil
        if not mynet_topology.has_key?(found_net)
          # This network is new
          mynet_topology[found_net] = Hash.new
          mynet_topology[found_net]['interfaces'] = Array.new
          mynet_topology[found_net]['name'] = net_topology[found_net]['name']
          mynet_topology[found_net]['firewall_zone'] = net_topology[found_net]['firewall_zone']
        end
        # Even if the net already existed, adding the interface
        mynet_topology[found_net]['interfaces'].push(iface)
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
