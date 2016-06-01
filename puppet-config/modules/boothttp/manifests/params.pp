#
class boothttp::params {

  $config_dir                      = '/public/'
  $config_dir_source               = '/path/to/sources'

  # Files and directories that can be downloaded by HTTP
  $config_dir_http                 = "${config_dir}/http"
  $menu_source                     = "${config_dir_source}/bootmenu.rb"
  $disk_source                     = "${config_dir_source}/disk"

  $supported_os                    = {
    'calibre9'                      => {
      'os'                         => 'calibre9',
    }
  }

}
