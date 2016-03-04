require 'hiera'

options = {
  :default => nil,
  :config => File.join(Hiera::Util.config_dir, 'puppet/hiera.yaml'),
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

options[:key] = "cluster_prefix"
prefix = hiera.lookup(options[:key], options[:default], options[:scope], nil, options[:resolution_type])

if Facter.value(:hostname) =~ /^#{prefix}([a-z]+)[0-9]*$/
  Facter.add('puppet_role') do
    setcode do
      $1
    end
  end

# ([a-z]+), i.e. www or logger have a puppet_role of www or logger
elsif Facter.value(:hostname) =~ /^#{prefix}([a-z]+)$/
  Facter.add('puppet_role') do
    setcode do
      $1
    end
  end

# Set to hostname if no patterns match
else
  Facter.add('puppet_role') do
    setcode do
      'default'
    end
  end
end
