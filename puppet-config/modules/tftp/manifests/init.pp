class tftp (
  $package_ensure    = $tftp::params::package_ensure,
  $packages          = $tftp::params::packages,
  $service_ensure    = $tftp::params::service_ensure,
  $service           = $tftp::params::service,
  $config_file       = $tftp::params::config_file,
  $config_options    = $tftp::params::config_options,  

) inherits tftp::params {

  validate_string($package_ensure)
  validate_array($packages)
  validate_string($service)
  validate_string($service_ensure)
  validate_absolute_path($config_file)
  validate_hash($config_options)

  anchor { 'tftp::begin': } ->
  class { '::tftp::install': } ->
  class { '::tftp::config': } ->
  class { '::tftp::service': } ->
  anchor { 'tftp::end': }

}
