class slurmd::install {

  if $slurmd::package_manage {

    package { $slurmd::package_name :
      ensure => $slurmd::package_ensure,
    }
  }
}
