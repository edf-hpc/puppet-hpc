#
class pam::pwquality::install inherits pam::pwquality {

  package { $pam::pwquality::pam_pwquality_package :
    ensure => $pam::pwquality::packages_ensure,
  }

}
