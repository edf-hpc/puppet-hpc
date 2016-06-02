class profiles::log::client {

  ## Hiera lookups

  $remote_type = hiera('profiles::log::client::remote_type')
  $log_local   = hiera('profiles::log::client::log_local')
  $server      = hiera('profiles::log::client::server')
  $port        = hiera('profiles::log::client::port')

  # Pass config options as a class parameter
  class { '::rsyslog::client':
  remote_type               => $remote_type,
  log_local                 => $log_local,
  server                    => $server,
  port                      => $port,
  }
}
