class mariadb::service {

  if $mariadb::service_manage {

    if ! ($mariadb::service_ensure in [ 'running', 'stopped' ]) {
      fail('service_ensure parameter must be running or stopped')
    }


    service { $mariadb::service_name :
      ensure     => $mariadb::service_ensure,
      enable     => $mariadb::service_enable,
      name       => $mariadb::service_name,
    }
  }
}
