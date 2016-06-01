#
class boottftp::params {

  $config_dir                      = '/public/ipxe'
  $config_dir_source               = '/path/to/sources'

  # Files that can be downloaded by FTP
  $config_dir_ftp                  = "${config_dir}/tftp"
  $ipxe_efi_source                 = "${config_dir_source}/ipxe.efi"
  $ipxe_legacy_source              = "${config_dir_source}/ipxe.legacy"

}
