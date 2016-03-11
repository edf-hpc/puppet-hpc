class slurm::service {

  if $slurm::service_manage == true {

    if ! ($slurm::service_ensure in [ 'running', 'stopped' ]) {
      fail('service_ensure parameter must be running or stopped')
    }


    if $slurm::enable_daemon {
      service { $slurm::service_dmn_name :
        ensure     => $slurm::service_ensure,
        enable     => $slurm::service_enable,
        name       => $slurm::service_dmn_name,
      }
    }
    if $slurm::enable_ctld {
      service { $slurm::service_ctld_name :
        ensure     => $slurm::service_ensure,
        enable     => $slurm::service_enable,
        name       => $slurm::service_ctld_name,
      }
    }
  }
}
