class tftp::install inherits tftp {

  package { $tftp::package_name:
    ensure => $tftp::package_ensure,
  }

}
