class slurm::install {

  if $slurm::package_manage {

    if $slurm::enable_daemon {
      package { $slurm::package_dmn_name :
        ensure => $slurm::package_ensure,
      }
    }

    if $slurm::enable_ctld {
     package { $slurm::package_ctld_name :
        ensure => $slurm::package_ensure,
      }
    }

    if $slurm::enable_client {
      package { $slurm::package_client_name :
        ensure => $slurm::package_ensure,
      }
    }
  }
}
