class munge::service {

  if $service::service_manage == true {

    if ! ($munge::service_ensure in [ 'running', 'stopped' ]) {
      fail('service_ensure parameter must be running or stopped')
    }

    service { $munge::service_name :
      ensure => $ntp::service_ensure,
      enable => $ntp::service_enable,
      name   => $ntp::service_name,
    }
  }
}
