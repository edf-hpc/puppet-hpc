#
define boothttp::printconfig ($os = 'calibre9') {

  $config_file     = "${boothttp::install::disk_dir}/${os}/install_config"
  $template_file   = "boothttp/install_config.${os}.erb"
  $virtual_address = $boothttp::virtual_address

  file { "${config_file}":
    ensure          => 'present',
    content         => template($template_file)
  }

}
