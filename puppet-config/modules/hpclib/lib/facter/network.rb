###### Initialize Hiera backend #######
require 'hiera'
require 'facter/application'
require 'facter/util/ip'
require 'facter/util/macaddress'

options = {
  :default => nil,
  :config  => File.join(Hiera::Util.config_dir, 'hiera.yaml'),
  :scope   => {},
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
mymasternet = Array.new 
hostfile = Hash.new 
netconfig = Hash.new
dhcpconfig = Hash.new
ifaces_target = Hash.new
ifaces_target = { 'eth0' => {'target' => 'eth0'}}
options[:key] = "master_network"
masternetwork = hiera.lookup(options[:key], options[:default], options[:scope], nil, options[:resolution_type])

### Begin parsing ###
if !masternetwork.nil? and masternetwork.length > 0 
  masternetwork.each do | line|
    ### Set mymasternet used to generate local network config ###
    if (eth_hwaddr.length > 0 and line.scan(/\b#{eth_hwaddr}\b/i)) or (h_name.length > 0 and line.scan(/\b#{h_name}\b/i))
      mymasternet = line.split(";") if mymasternet.length == 0
    end
    element = Array.new; element = line.split(";") 
    i = 0; macadds = Array.new; macadds = element[i].split(",") unless element[i].empty?
    i = 2; hnames = Array.new; hnames = element[i].split(",") unless element[i].empty?
    i = 3; addresses = Array.new; addresses = element[i].split(",") unless element[i].empty?
    i = 5; dhcpd = Array.new; dhcpd = element[i].split(",") unless element[i].empty?
    i = 7; hosts = Array.new; hosts = element[i].split(",") unless element[i].empty?
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

i = 1; ifaces = Array.new; ifaces = mymasternet[i].split(",") unless mymasternet[i].empty? 
i = 3; addresses = Array.new; addresses = mymasternet[i].split(",") unless mymasternet[i].empty? 
i = 4; netmasks = Array.new; netmasks = mymasternet[i].split(",") unless mymasternet[i].empty? 
i = 6; netcfg = Array.new; netcfg = mymasternet[i].split(",") unless mymasternet[i].empty? 
### Set netconfig used to generate local network config ###
### Structure: {"interface"=>["10.0.0.1/255.255.255.0"]} ###
netcfg.each do | triplet| 
  index = Array.new; index = triplet.split("@") 
  itf = index[0].to_i; add = index[1].to_i ; ntm = index[2].to_i
  tmp = if netconfig.has_key?(ifaces[itf]) then netconfig[ifaces[itf]] else Array.new end
  tmp.push(addresses[add]+"/"+netmasks[ntm])
  netconfig[ifaces[itf]] = tmp
  ifaces_target[ifaces[itf]]= {'target' => ifaces[itf]} if os == 'Redhat'
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

Facter.add('ifaces_target') do
  setcode do
    ifaces_target
  end
end
