class profiles::software::intel {

  ## Hiera lookups

  $license_path    = hiera('profiles::software::intel::license_path')
  $binary_path     = hiera('profiles::software::intel::binary_path')
  $vendor_name     = hiera('profiles::software::intel::vendor_name')
  $user_home       = hiera('profiles::software::intel::user_home')
  $systemd_service = hiera('profiles::software::intel::systemd_service')
  $systemd_config  = hiera('profiles::software::intel::systemd_config') 

  # Pass config options as a class parameter
  include flexlm::params
  flexlm::service { 'intel':
    binary_path     => $binary_path,
    license_path    => $license_path,
    vendor_name     => $vendor_name,
    user_home       => $user_home,
    systemd_config  => $systemd_config,
    systemd_service => $systemd_service,
}  

}
