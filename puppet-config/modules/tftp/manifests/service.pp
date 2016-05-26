class tftp::service inherits tftp {

  if ! ($tftp::service_ensure in [ 'running', 'stopped' ]) {
    fail('service_ensure parameter must be running or stopped')
  }

  service { $tftp::service :
    ensure     => $tftp::service_ensure,
  }

}
