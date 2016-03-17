class tftp::params {

  ### Module variables ###
  $enable_ipxe       = true
  $package_ensure    = 'present'
  $service_ensure    = 'running'
  $service_enable    = true
  $root_dir_path     = '/admin/public/tftp'
  $ipxe_efi_image    = "${root_dir_path}/ipxe.efi" 
  $ipxe_efi_src      = 'puppet:///modules/tftp/ipxe.efi'
  $ipxe_legacy_image = "${root_dir_path}/ipxe.legacy"
  $ipxe_legacy_src   = 'puppet:///modules/tftp/ipxe.legacy' 

  case $::osfamily {
    'RedHat': {
      $package_manage    =  true
      $package_name      = ['tftp-server']
      $service_manage    = true
      $service_name      = 'tftp'
    }
    'Debian': {
      $package_manage    =  true
      $package_name      = ['tftpd-hpa']
      $service_manage    = true
      $service_name      = 'tftpd-hpa'
      $main_conf_file    = '/etc/default/tftpd-hpa'
      $tftp_conf_options = {
        'TFTP_USERNAME'    => '"tftp"',
        'TFTP_DIRECTORY'   => '"/srv/tftp"',
        'TFTP_ADDRESS'     => '"0.0.0.0:69"',
        'TFTP_OPTIONS'     => '"--secure --verbose --create"',
      }
    }
    default: {
      $package_manage  = false
      $service_manage  = false
    }
  }
}
