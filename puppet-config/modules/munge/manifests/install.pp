class munge::install {

  if $munge::package_manage {

    package { $munge::package_name:
      ensure => $munge::package_ensure,
    }
  }
}
