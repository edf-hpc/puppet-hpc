#
class profiles::bootsystem::server {

  $prefix          = hiera('cluster_prefix')
  $virtual_address = $::hostfile["${prefix}${::puppet_role}"]

  # Install and configure the server tftp
  $tftp_config_options = hiera_hash('profiles::bootsystem::tftp_config_options')
  
  class { '::tftp':
    config_options     => $tftp_config_options,
  }

  # Install files necessary for boot
  $config_dir_ftp      = hiera('profiles::bootsystem::tftp_dir')
  $ipxe_efi_source     = hiera('profiles::bootsystem::ipxe_efi_source')
  $ipxe_legacy_source  = hiera('profiles::bootsystem::ipxe_leg_source')

  class { '::boottftp':
    config_dir_ftp             => $config_dir_ftp,
    ipxe_efi_source            => $ipxe_efi_source,
    ipxe_legacy_source         => $ipxe_legacy_source,
  }

  $config_dir_http     = hiera('profiles::bootsystem::http_dir')
  $menu_source         = hiera('profiles::bootsystem::menu_source')
  $disk_source         = hiera('profiles::bootsystem::http_disk_source')
  $supported_os        = hiera('profiles::bootsystem::supported_os')

  class { '::boothttp':
    config_dir_http            => $config_dir_http,
    menu_source                => $menu_source,
    disk_source                => $disk_source,
    supported_os               => $supported_os,
    virtual_address            => $virtual_address,
  }

}
