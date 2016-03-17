class tftp::install {

   if $tftp::package_manage {

    package { $tftp::package_name:
      ensure => $tftp::package_ensure,
    }
  }

}
