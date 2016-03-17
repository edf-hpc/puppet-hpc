class tftp::config {

  if $tftp::config_manage {

    hpclib::print_config { $tftp::main_conf_file :
      style   => 'keyval',
      data    => $tftp::tftp_conf_options,
      notify  => Service[$tftp::service_name],
    }

    if $tftp::enable_ipxe {
      file { $tftp::ipxe_efi_image :  
        source       => $tftp::ipxe_efi_src,
        validate_cmd => "test -d ${tftp::root_dir_path}",
      }

      file { $tftp::ipxe_legacy_image :
        source       => $tftp::ipxe_legacy_src,
        validate_cmd => "test -d ${tftp::root_dir_path}",
      }
    }
  }
}
