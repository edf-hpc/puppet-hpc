#
class boothttp (

  $virtual_address,
  $config_dir_http                 = $boothttp::params::config_dir_http,
  $menu_source                     = $boothttp::params::menu_source,
  $disk_source                     = $boothttp::params::disk_source,
  $supported_os                    = $boothttp::params::supported_os,

) inherits boothttp::params {

  validate_absolute_path($config_dir_http)
  validate_absolute_path($menu_source)
  validate_absolute_path($disk_source)
  validate_hash($supported_os)

  anchor { 'boothttp::begin': } ->
  class { '::boothttp::install': } ->
  class { '::boothttp::config': } ->
  anchor { 'boothttp::end': }

}
