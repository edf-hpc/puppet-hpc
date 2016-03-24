#
class multipath::params {

  $config              = '/etc/multipath.conf'
  $config_opts         = {
    'defaults'             => {
      'user_friendly_names'=> 'yes',
    },
    'blacklist'            => {},
  }
  $packages_ensure     = 'present'
  case $::osfamily {
    'Debian': { 
      $packages        = ['multipath-tools']
    }
    'Redhat': {
      $packages        = ['device-mapper-multipath']
    }
    default {}
  }

}
