class ntp::commons (
  $preferred_servers = $ntp::params::preferred_servers,
  $servers           = $ntp::params::servers,
  $restrict          = $ntp::params::restrict,
  $config            = $ntp::params::config,
  $service_name      = $ntp::params::service_name,
  $package_list      = $ntp::params::package_list,
  $default_config    = $ntp::params::default_config,
  $service_opts      = $ntp::params::service_opts,
) inherits ntp::params {

  hpclib::print_config { $default_config :
    style   => 'keyval',
    params  => $service_opts,
    require => Package[$package_list]
  }

  $ntp_files = {
    "${config}"     => {
      content    => template('ntp/ntp_conf.erb'),
      require    => Package[$package_list],
    },
  }

  create_resources(file,$ntp_files)

  $ntp_services = {
    "${service_name}" => {
      ensure     => 'running',
      require    => Package[$package_list],
      subscribe  => [File[$config],File[$default_config]],
    },
  }

  create_resources(service,$ntp_services)

  package { $package_list :
    ensure     => 'installed',
  }
}
