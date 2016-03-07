class postfix::commons (
  $pkgs                = $postfix::params::pkgs,
  $serv                = $postfix::params::serv,
  $cfg                 = $postfix::params::cfg,
  $cfg_opts            = $postfix::params::cfg_opts,
  $profile_opts        = $postfix::params::profile_opts,

) inherits postfix::params {

  $main_config = merge($cfg_opts,$profile_opts)

  package { $pkgs :}

  service { $serv :
    require   => Package[$pkgs],
    subscribe => File[$cfg],
  }

  tools::print_config { $cfg :
    style   => 'keyval',
    params  => $main_config,
    require => Package[$pkgs]
  }

}
