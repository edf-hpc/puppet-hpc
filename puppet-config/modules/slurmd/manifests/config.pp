class slurmd::config {

  if $slurmd::config_manage {

    require slurmcommons

    if $slurmd::enable_cgroup {
      hpclib::print_config { $slurmd::cgroup_conf_file:
        style        => 'keyval',
        data         => $::slurmd::cgroup_options,
      }

      ensure_resource('file', "${slurmd::cgroup_rel_path}",{'ensure' => 'directory' })

      file { $slurmd::cgroup_relscript_file:
        mode       => 0744, # must be executable only by root
        owner      => 'root',
        source     => $slurmd::cgroup_relscript_src,
        require    => File[$slurmd::cgroup_rel_path],
      }  

      $cgroup_links = {
        "${slurmd::cgroup_rscpuset_file}" => { },
        "${slurmd::cgroup_rs_freez_file}" => { },
        "${slurmd::cgroup_rs_mem_file}" => { },
      }

      $cgroup_ln_default = {
        ensure     => link,
        target     => $slurmd::cgroup_relscript_file,
        require    => File[$slurmd::cgroup_relscript_file],
      }
      create_resources(file,$cgroup_links,$cgroup_ln_default)
    }
  }
}
