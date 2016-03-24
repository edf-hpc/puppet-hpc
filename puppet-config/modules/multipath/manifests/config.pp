#
class multipath::config inherits multipath {
  
  $config_opts = $multipath::config_opts
  file { $multipath::config :
    content => template('multipath/multipath_conf.erb'),
    require => Package[$multipath::packages],
  }

}
