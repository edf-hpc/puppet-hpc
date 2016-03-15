class slurmclient::install {

  if $slurmclient::package_manage {
    package { $slurmclient::package_name :
      ensure => $slurmclient::package_ensure,
    }
  }
}
