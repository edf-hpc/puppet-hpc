class tftp::service {

  if $tftp::service_manage == true {

    if ! ($tftp::service_ensure in [ 'running', 'stopped' ]) {
      fail('service_ensure parameter must be running or stopped')
    }

    service { $tftp::service_name :
      ensure     => $tftp::service_ensure,
      enable     => $tftp::service_enable,
      name       => $tftp::service_name,
    }
  }
}
