class alternatives (
  $config_manage       = $::alternatives::params::config_manage,
  $altname             = $::alternatives::params::altname,
  $altpath             = $::alternatives::params::altpath,
  $exec_command        = $::alternatives::params::exec_command,
) inherits alternatives::params {

  validate_bool($config_manage)

  if $config_manage {
    validate_string($altname)
    validate_absolute_path($altpath)
    validate_absolute_path($exec_command)
  }

  anchor { 'alternatives::begin': } ->
  class { '::alternatives::config': } ->
  anchor { 'alternatives::end': }

}

