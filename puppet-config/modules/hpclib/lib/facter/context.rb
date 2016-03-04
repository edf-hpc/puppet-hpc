require 'facter/operatingsystem'
os = Facter.value(:operatingsystem)
$mycontext = String.new

case os
  when "RedHat" then
    cmdline = File.read('/proc/cmdline')
    if cmdline.match('ks=') then
      $mycontext = 'installer'
    else
      $mycontext = 'ondisk'
    end

  when "Debian" then
    if File.directory?('/run/systemd') then
      if File.directory?('/lib/live/mount/overlay') then
        $mycontext = 'diskless-postinit'
      else
        $mycontext = 'ondisk'
      end
    else
      if File.directory?('/lib/live/mount/overlay') then
        $mycontext = 'diskless-preinit'
      else
        $mycontext = 'installer'
      end
    end
end

Facter.add('puppet_context') do
  setcode do 
    $mycontext
  end
end
