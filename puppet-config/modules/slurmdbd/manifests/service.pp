class slurmdbd::service {

  if $slurmdbd::service_manage {

    if ! ($slurmdbd::service_ensure in [ 'running', 'stopped' ]) {
      fail('service_ensure parameter must be running or stopped')
    }


    service { $slurmdbd::service_name :
      ensure     => $slurmdbd::service_ensure,
      enable     => $slurmdbd::service_enable,
      name       => $slurmdbd::service_name,
    }
  }
}
