class slurmctld::service {

  if $slurmctld::service_manage {

    if ! ($slurmctld::service_ensure in [ 'running', 'stopped' ]) {
      fail('service_ensure parameter must be running or stopped')
    }


    service { $slurmctld::service_name :
      ensure     => $slurmctld::service_ensure,
      enable     => $slurmctld::service_enable,
      name       => $slurmctld::service_name,
    }
  }
}
