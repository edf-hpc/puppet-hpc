#
class sudo::install inherits sudo {

  package { $sudo::packages :
    ensure => $sudo::packages_ensure,
  }

}
