class slurmclient (
  $config_manage  = $slurmclient::params::config_manage,
  $package_manage = $slurmclient::params::package_manage,
  $package_ensure = $slurmclient::params::package_ensure,
  $package_name   = $slurmclient::params::package_name,
) inherits slurmclient::params {
 
  validate_bool($config_manage)
  validate_bool($package_manage)
  if $package_manage {
    validate_string($package_ensure)
    validate_array($package_name)
  }

  anchor { 'slurmclient::begin': } ->
#  class { '::slurmclient::install': } ->
  class { '::slurmclient::config': } ->
  anchor { 'slurmclient::end': }
}
