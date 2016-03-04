require 'facter/application'
require 'facter/util/macaddress'
require 'facter/osfamily'
  ### Define variables ###
$eth_hwaddr = Facter.value(:macaddress_eth0)
$h_name = Facter.value(:hostname)
os = Facter.value(:osfamily)
$filemaster  = "/admin/restricted/cecile/puppet-config/modules/prerequisites/lib/puppet/external/cluster_data/master_network.csv"
$mymasternet = Array.new 
$interfaces = Hash.new 
$ifaces_target = Hash.new 
$ifaces_target = { 'eth0' => {'target' => 'eth0'}}
 
# Set arrays @masternetwork and @mymasternet from file master_network
if File.exist?($filemaster)
  File.open($filemaster).read.each_line do |line|
    unless line.match('#')
      if ( $eth_hwaddr.length > 0 and line.match(/\b#{$eth_hwaddr}\b/i) ) or ( $h_name.length > 0 and line.match(/#{$h_name}/) ) 
        $mymasternet = line.chomp.split(';')
      end
    end
  end
end

Facter.add('mymasternet') do
  setcode do
    $mymasternet
  end
end

# set hash @netconf from array @mymasternet
i = 1; ifaces = Array.new; ifaces = $mymasternet[i].split(",") unless $mymasternet[i].empty?
i = 3; addresses = Array.new; addresses = $mymasternet[i].split(",") unless $mymasternet[i].empty?
i = 4; netmasks = Array.new; netmasks = $mymasternet[i].split(",") unless $mymasternet[i].empty?
i = 6; netcfg = Array.new; netcfg = $mymasternet[i].split(",") unless $mymasternet[i].empty?
netcfg.each do | triplet|
  index = Array.new; index = triplet.split("@")
  itf = index[0].to_i; add = index[1].to_i ; ntm = index[2].to_i
  tmp = if $interfaces.has_key?(ifaces[itf]) then $interfaces[ifaces[itf]] else Array.new end
  tmp.push(addresses[add]+"/"+netmasks[ntm])
  $interfaces[ifaces[itf]] = tmp
  $ifaces_target[ifaces[itf]]= {'target' => ifaces[itf]} if os == 'Redhat'
end

Facter.add('netconfig') do
  setcode do
    $interfaces
  end
end

Facter.add('ifaces_target') do
  setcode do
    $ifaces_target
  end
end

