#
class pam::access (
  $pam_ssh_config            = $pam::params::pam_ssh_config,
  $access_config             = $pam::params::access_config,
  $access_config_opts        = $pam::params::access_config_opts,
  $access_exec               = $pam::params::access_exec,
) inherits pam::params {

  validate_absolute_path($access_config)
  validate_array($access_config_opts)
  validate_string($access_exec)


  # Array concatenation (Can be simplified with future parser)  
  $array_to_concat = [$access_config_opts,'- : ALL : ALL']
  $config_opts = flatten($array_to_concat)

  hpclib::print_config { $access_config :
    style   => 'linebyline',
    data    => $config_opts,
    mode    => 0600,
    notify  => Exec[$access_exec],
  }

  exec { $access_exec :
    command => $access_exec,
    require => File[$pam_ssh_config],
  }

}
