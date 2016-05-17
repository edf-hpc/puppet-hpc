#
class pam::pwquality (
  $pam_pwquality_package        = $pam::params::pam_pwquality_package, 
  $pam_pwquality_exec           = $pam::params::pam_pwquality_exec,
  $pam_pwquality_config         = $pam::params::pam_pwquality_config,
  $packages_ensure              = $pam::params::packages_ensure,
) inherits pam::params {

  validate_array($pam_pwquality_package)
  validate_string($pam_pwquality_exec)
  validate_absolute_path($pam_pwquality_config)
  validate_string($packages_ensure)

  anchor { 'pam::pwquality::begin': } ->
  class { '::pam::pwquality::install': } ->
  class { '::pam::pwquality::config': } ->
  anchor { 'pam::pwquality::end': }

}
