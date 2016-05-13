#
class pam::slurm::install inherits pam::slurm {

  package { $pam::slurm::pam_slurm_package :
    ensure => $pam::slurm::packages_ensure,
  }

  file { $pam::slurm::pam_slurm_config :
    ensure => 'present',
  }

}
