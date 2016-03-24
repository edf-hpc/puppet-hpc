#
class multipath (
  $config             = $multipath::params::config,
  $config_opts        = $multipath::params::config_opts,
  $packages           = $multipath::params::packages,
  $packages_ensure    = $multipath::params::packages_ensure,
) inherits multipath::params {

  validate_absolute_path($config)
  validate_hash($config_opts)
  validate_array($packages)
  validate_string($packages_ensure)  

  anchor { 'multipath::begin': } ->
  class { '::multipath::install': } ->
  class { '::multipath::config': } ->
  anchor { 'multipath::end': }

}
