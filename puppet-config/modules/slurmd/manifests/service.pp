class slurmd::service {

  if $slurmd::service_manage {

    if ! ($slurmd::service_ensure in [ 'running', 'stopped' ]) {
      fail('service_ensure parameter must be running or stopped')
    }

    service { $slurmd::service_name :
      ensure     => $slurmd::service_ensure,
      enable     => $slurmd::service_enable,
      name       => $slurmd::service_name,
    }
  }
}
