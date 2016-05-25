#
class iscdhcp::install inherits iscdhcp {

  package { $iscdhcp::packages :
    ensure => $iscdhcp::packages_ensure,
  }

}
