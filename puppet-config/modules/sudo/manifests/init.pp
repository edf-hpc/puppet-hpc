#
class sudo (
  $packages               = $sudo::params::packages,
  $packages_ensure        = $sudo::params::packages_ensure,
  $config_file            = $sudo::params::config_file,
  $config_options         = $sudo::params::config_options,
) inherits sudo::params {
  
  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_array($config_options) 

  anchor { 'sudo::begin': } ->
  class { '::sudo::install': } ->
  class { '::sudo::config': } ->
  anchor { 'sudo::end': }

}
