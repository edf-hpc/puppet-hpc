#
class multipath::install inherits multipath {

  package { $multipath::packages :
    ensure  => $multipath::packages_ensure,
  }

}
