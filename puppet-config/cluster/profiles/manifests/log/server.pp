class profiles::log::server {

  ## Hiera lookups

  $server_dir    = hiera('profiles::log::server::server_dir')
  $custom_config = hiera('profiles::log::server::custom_config')
  $firstaction   = hiera('profiles::log::server::logrotate_firstaction')

  # Pass config options as a class parameter
  class { '::rsyslog::server':
    server_dir    => $server_dir,
    custom_config => $custom_config,
  }
  logrotate::rule { 'remotelog':
    path          => "${server_dir}*/*",
    compress      => true,
    missingok     => true,
    firstaction   => $firstaction,
    copytruncate  => true,
    create        => false,
    delaycompress => true,
    mail          => false,
    rotate        => '30',
    sharedscripts => true,
    size          => '5M',
    rotate_every  => day,
    postrotate    => 'invoke-rc.d rsyslog rotate > /dev/null',
  }

}
