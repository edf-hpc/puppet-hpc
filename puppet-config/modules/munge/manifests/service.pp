class munge::service {

  if $munge::service_manage == true {

    if ! ($munge::service_ensure in [ 'running', 'stopped' ]) {
      fail('service_ensure parameter must be running or stopped')
    }

    service { $munge::service_name :
      ensure     => $munge::service_ensure,
      enable     => $munge::service_enable,
      name       => $munge::service_name,
    }
  }
}
