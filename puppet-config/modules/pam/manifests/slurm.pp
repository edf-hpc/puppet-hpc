#
class pam::slurm (
  $packages_ensure           = $pam::params::packages_ensure,
  $pam_slurm_package         = $pam::params::pam_slurm_package,
  $pam_slurm_config          = $pam::params::pam_slurm_config,
  $pam_slurm_exec            = $pam::params::pam_slurm_exec,
  $pam_slurm_condition       = $pam::params::pam_slurm_condition,
) inherits pam::params {
   
  validate_string($packages_ensure)
  validate_array($pam_slurm_package)
  validate_absolute_path($pam_slurm_config)
  validate_string($pam_slurm_exec)
  validate_string($pam_slurm_condition)

  anchor { 'pam::slurm::begin': } ->
  class { '::pam::slurm::install': } -> 
  class { '::pam::slurm::config': } ->
  anchor { 'pam::slurm::end': }

}
