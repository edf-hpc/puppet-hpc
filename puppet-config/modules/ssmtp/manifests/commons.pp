class ssmtp::commons (
  $pkgs                = $ssmtp::params::pkgs,
  $cfg                 = $ssmtp::params::cfg,
  $cfg_opts            = $ssmtp::params::cfg_opts,
) inherits ssmtp::params {

  $main_config = merge($cfg_opts,$profile_opts)

  package { $pkgs :}

  tools::print_config { $cfg :
    style   => 'keyval',
    params  => $main_config,
    require => Package[$pkgs]
  }

}
