#
class pam::slurm::config inherits pam::slurm {

 exec { $pam::slurm::pam_slurm_exec :
    command => $pam::slurm::pam_slurm_exec,
    require => File[$pam::slurm::pam_slurm_config],
    onlyif => $pam::slurm::pam_slurm_condition,
  }

}
