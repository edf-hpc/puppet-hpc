#
class boottftp (

  $config_dir_ftp                  = $ipxe::params::config_dir_ftp,
  $ipxe_efi_source                 = $ipxe::params::ipxe_efi_source,
  $ipxe_legacy_source              = $ipxe::params::ipxe_legacy_source,

) inherits boottftp::params {

  validate_absolute_path($config_dir_ftp)
  validate_absolute_path($ipxe_efi_source)
  validate_absolute_path($ipxe_legacy_source)
  
  $ipxe_efi_file                   = "${config_dir_ftp}/ipxe.efi"
  $ipxe_legacy_file                = "${config_dir_ftp}/ipxe.legacy"

  anchor { 'boottftp::begin': } ->
  class { '::boottftp::install': } ->
  anchor { 'boottftp::end': }

}
