class profiles::http::mirror {

  ## Hiera lookups
  
  $port           = hiera('profiles::http::port')
  $docroot        = hiera('profiles::http::mirror::docroot')
  $serveradmin    = hiera('profiles::http::serveradmin')
  $error_log_file = hiera('profiles::http::error_log_file')
  $log_level      = hiera('profiles::http::log_level')
  $website_dir    = hiera('website_dir')
  $cluster_prefix = hiera('cluster_prefix')

  include apache

  file { "$website_dir" :
    ensure => directory,
  }

  # Pass config options as a class parameter

  apache::vhost { "${cluster_prefix}${my_http_mirror}" :
    port           => $port,
    docroot        => $docroot,
    serveradmin    => $serveradmin,
    error_log_file => $error_log_file,
    log_level      => $log_level,
  }
}
