class slurmdbd::install {

  if $slurmdbd::package_manage {

    package { $slurmdbd::package_name :
      ensure => $slurmdbd::package_ensure,
    }

  }
}
