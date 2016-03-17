class tftp (
  $enable_ipxe       = $tftp::params::enable_ipxe,
  $package_manage    = $tftp::params::package_manage,
  $package_ensure    = $tftp::params::package_ensure,
  $package_name      = $tftp::params::package_name,
  $service_manage    = $tftp::params::service_manage,
  $service_ensure    = $tftp::params::service_ensure,
  $service_name      = $tftp::params::service_name,
  $main_conf_file    = $tftp::params::main_conf_file,
  $tftp_conf_options = $tftp::params::tftp_conf_options,  
  $root_dir_path     = $tftp::params::root_dir_path,
  $ipxe_efi_image    = $tftp::params::ipxe_efi_image,
  $ipxe_efi_src      = $tftp::params::ipxe_efi_src,
  $ipxe_legacy_image = $tftp::params::ipxe_legacy_image,
  $ipxe_legacy_src   = $tftp::params::ipxe_legacy_src,

) inherits tftp::params {

  validate_boolean($enable_ipxe)
  validate_boolean($package_manage)
  validate_string($package_ensure)
  validate_array($package_name)
  validate_boolean($service_manage)
  validate_string($service_name)
  validate_string($service_ensure)
  validate_absolute_path($main_conf_file)
  validate_hash($tftp_conf_options)
  if $enable_ipxe {
    validate_absolute_path($root_dir_path)
    validate_absolute_path($pxe_efi_image)
    validate_absolute_path($ipxe_legacy_image)
    validate_string($ipxe_efi_src)
    validate_string($ipxe_legacy_src)
  }

  anchor { 'tftp::begin': } ->
  class { '::tftp::install': } ->
  class { '::tftp::config': } ->
  class { '::tftp::service': } ->
  anchor { 'tftp::end': }

}
