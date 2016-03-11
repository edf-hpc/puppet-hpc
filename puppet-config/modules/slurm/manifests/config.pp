class slurm::config {

  $directories_default = {
    ensure                    => 'directory',
  }

  if $slurm::enable_conf {

    $conf_directories = {
      "$slurm::bin_dir_path"    => { },
      "$slurm::conf_dir_path"   => { },
      "$slurm::logs_dir_path"   => { },
      "$slurm::script_dir_path" => { },
    }

    create_resources(file,$conf_directories,$directories_default)

    hpclib::print_config { $slurm::main_conf_file :
      style        => 'ini_flat',
      data         => $slurm::slurm_conf_options,
      require      => File["$slurm::conf_dir_path"],
    }

    hpclib::print_config { $slurm::part_conf_file :
      style        => 'linebyline',
      data         => $slurm::partitions_conf,
      require      => File["$slurm::conf_dir_path"],
    }

    if enable_topology {

      hpclib::print_config { $slurm::topo_conf_file :
        style        => 'linebyline',
        data         => $slurm::topology_conf,
        require      => File["$slurm::conf_dir_path"],
      }
    }
  }
  if $slurm::enable_cgroup {

     $cgroup_directories = {
      "$slurm::cgroup_rel_path" => { },
    }
    create_resources(file,$cgroup_directories,$directories_default)

    file { $slurm::cgroup_relscript_file:
      mode       => 0744, # must be executable only by root
      owner      => 'root',
      source     => $slurm::cgroup_relscript_src,
      require    => File[$slurm::cgroup_rel_path],
    }

    $cgroup_links = {
      "${slurm::cgroup_rscpuset_file}" => { },
      "${slurm::cgroup_rs_freez_file}" => { },
      "${slurm::cgroup_rs_mem_file}" => { },
    }

    $cgroup_ln_default = {
      ensure     => link,
      target     => $slurm::cgroup_relscript_file,
      require    => File[$slurm::cgroup_relscript_file],
    }
    create_resources(file,$cgroup_links,$cgroup_ln_default)
  }
#  $jobsc_ctl_lua         = $slurm::params::jobsc_ctl_lua
#  $cgroup_conf_file      = $slurm::params::cgroup_conf_file
#  $cgroup_conf_tmpl      = $slurm::params::cgroup_conf_tmpl
}
