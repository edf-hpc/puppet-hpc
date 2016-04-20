require 'yaml'
require 'hiera'

tracked_profiles=['server','relay','mirror']

hiera_cfg_file = File.join(Hiera::Util.config_dir, 'puppet/hiera.yaml')
hiera_cfg = YAML.load_file(hiera_cfg_file)
profdir = "#{hiera_cfg[:yaml][:datadir]}/generic/default/roles"

myprofiles = Array.new
profiles = Hash.new
roles = Array.new
Dir.entries(profdir).each do |element|
  if element != "." && element != ".." && element =~ /.yaml$/
    roles.push(File.basename(element,".yaml"))
  end
end
myrole = Facter.value(:puppet_role)

options = {
  :default => nil,
  :config => hiera_cfg_file,
  :scope => {},
  :key => nil,
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

########################################
options[:key] = "profiles"
roles.each do |currole|
  curprofiles = Array.new
  options[:scope] = {
    "puppet_role" => currole,
  }
  curprofiles = hiera.lookup(options[:key], options[:default], options[:scope], nil, options[:resolution_type])
  if ! curprofiles.nil?
    profiles[currole] = curprofiles
    if currole == myrole
      myprofiles = curprofiles
    end
    curprofiles.each do |prof|
      expr=prof.split('::')
      tracked_profiles.each do |keywd|
        if expr[2] == keywd 
          currfact='my_'+expr[1]+'_'+keywd
          Facter.add(currfact) do
            setcode do
              currole
            end
          end
        end
      end
    end
  end
end

Facter.add('myprofiles') do
  setcode do
    myprofiles
  end
end

Facter.add('profiles') do
  setcode do
    profiles
  end
end

