class tftp::install inherits tftp {

  package { $tftp::packages :
    ensure => $tftp::package_ensure,
  }

}
