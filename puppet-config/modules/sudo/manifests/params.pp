#
class sudo::params {
  
  $packages                   = ['sudo']
  $packages_ensure            = 'present'
  $config_file                = '/etc/sudoers'
  $config_options             = ''

}
