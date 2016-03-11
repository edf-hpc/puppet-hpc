class profiles::ntp::server {

  ## Hiera lookups
  $preferred_servers = hiera_array('profiles::ntp::server::site_preferred_servers')
  $servers           = hiera_array('profiles::ntp::server::site_servers')

  # Pass server name as a class parameter
  class { '::ntp':
    preferred_servers           => $preferred_servers,
    servers                     => $servers,
  }

  # Modify default options of ntp service
  $srv_name = $ntp::params::service_name
  $srv_def_cfg = hiera('profiles::ntp::srv_def_cfg')
  $srv_opts = hiera('profiles::ntp::srv_opts')
  hpclib::print_config { $srv_def_cfg :
    style   => 'keyval',
    data    => $srv_opts,
    notify  => Service[$srv_name],
  }

}
