class boothttp::install inherits boothttp {

  $menu_dir                        = "${boothttp::config_dir_http}/cgi-bin"
  $menu_file                       = "${menu_dir}/bootmenu.rb"
  $disk_dir                        = "${boothttp::config_dir_http}/disk"
  ensure_resource('file',["${boothttp::config_dir_http}",$menu_dir],{'ensure' => 'directory'})

  $boot_files          = {
    "${menu_file}"        => {
      source                   => $boothttp::menu_source,
      mode                     => '755',
      validate_cmd             => "test -d `dirname ${menu_file}`",
    },
    "${disk_dir}"        => {
      source                   => $boothttp::disk_source,
      ensure                   => 'directory',
      recurse                  => 'remote',
      validate_cmd             => "test -d `dirname ${disk_dir}`",
    },
  }

  create_resources(file,$boot_files)

}

