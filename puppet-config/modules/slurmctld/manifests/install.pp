class slurmctld::install {

  if $slurmctld::package_manage {
    package { $slurmctld::package_name :
      ensure => $slurmctld::package_ensure,
    }
  }
}
