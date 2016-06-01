class tftp::params {

  ### Module variables ###
  $package_ensure    = 'present'
  $service_ensure    = 'running'

  case $::osfamily {
    'RedHat': {
      $packages          = ['tftp-server']
      $service           = 'tftp'
    }
    'Debian': {
      $packages          = ['tftpd-hpa']
      $service           = 'tftpd-hpa'
      $config_file       = '/etc/default/tftpd-hpa'
      $config_options = {
        'TFTP_USERNAME'    => '"tftp"',
        'TFTP_DIRECTORY'   => '"/srv/tftp"',
        'TFTP_ADDRESS'     => '"0.0.0.0:69"',
        'TFTP_OPTIONS'     => '"--secure --verbose --create"',
      }
    }
    default: {
    }
  }
}
