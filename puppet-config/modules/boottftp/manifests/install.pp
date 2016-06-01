class boottftp::install inherits boottftp {

  ensure_resource('file',["${boottftp::config_dir_ftp}"],{'ensure' => 'directory'})

  $boot_files          = {
    "${boottftp::ipxe_efi_file}"    => {
      source                   => $boottftp::ipxe_efi_source,
      validate_cmd             => "test -d `dirname ${boottftp::ipxe_efi_file}`",
    },
    "${boottftp::ipxe_legacy_file}"    => {
      source                   => $boottftp::ipxe_legacy_source,
      validate_cmd             => "test -d `dirname ${boottftp::ipxe_legacy_file}`",
    },
  }

  create_resources(file,$boot_files)

}

