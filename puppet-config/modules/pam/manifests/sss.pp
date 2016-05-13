#
class pam::sss (
  $packages_ensure           = $pam::params::packages_ensure,
  $pam_sss_package           = $pam::params::pam_sss_package,
) inherits pam::params {
   
  validate_string($packages_ensure)
  validate_array($pam_sss_package)

  package { $pam_sss_package :
    ensure   => $packages_ensure,
  }

}
