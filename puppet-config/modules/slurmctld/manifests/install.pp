class slurmctld::install {

  if $slurmctld::package_manage {
    package { $slurmctld::package__name :
      ensure => $slurmctld::package_ensure,
    }
  }
}
