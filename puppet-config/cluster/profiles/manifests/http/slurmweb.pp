class profiles::http::slurmweb {

  ## Hiera lookups
  
  $port           = hiera('profiles::http::port')
  $docroot        = hiera('profiles::http::slurmweb::docroot')
  $serveradmin    = hiera('profiles::http::serveradmin')
  $error_log_file = hiera('profiles::http::error_log_file')
  $log_level      = hiera('profiles::http::log_level')
  $cluster_prefix = hiera('cluster_prefix')
  $packages       = hiera_array('profiles::http::slurmweb::packages')

  # Pass config options as a class parameter

  include apache

  apache::vhost { "${hostname}" :
    port           => $port,
    docroot        => $docroot,
    serveradmin    => $serveradmin,
    error_log_file => $error_log_file,
    log_level      => $log_level,
  } ->

  package { "${packages}" :
    ensure => latest,
  }
  
  exec { 'a2enconf-javascript-common' :
    command => '/usr/sbin/a2enconf javascript-common',
    creates => '/etc/apache2/conf-enabled/javascript-common.conf',
    require => Package[$packages],
  }

  exec { 'a2enconf-slurm-web-restapi' :
    command => '/usr/sbin/a2enconf slurm-web-restapi',
    creates => '/etc/apache2/conf-enabled/slurm-web-restapi.conf',
    require => Package[$packages],
  }

}
