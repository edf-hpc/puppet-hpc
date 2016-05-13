#
class pam (
  $packages                  = $pam::params::packages,
  $packages_ensure           = $pam::params::packages_ensure,
  $pam_modules_config_dir    = $pam::params::pam_modules_config_dir,
  $pam_ssh_config            = $pam::params::pam_ssh_config,
) inherits pam::params {
   
  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($pam_modules_config_dir)
  validate_absolute_path($pam_ssh_config)

  class { '::pam::install': } 

}
