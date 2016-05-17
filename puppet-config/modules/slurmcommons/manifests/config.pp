class slurmcommons::config {

  ensure_resource('file', "${slurmcommons::bin_dir_path}",{'ensure' => 'directory' })
  ensure_resource('file', "${slurmcommons::conf_dir_path}",{'ensure' => 'directory' })
  ensure_resource('file', "${slurmcommons::logs_dir_path}",{'ensure' => 'directory' })
  ensure_resource('file', "${slurmcommons::script_dir_path}",{'ensure' => 'directory' })

  hpclib::print_config { $slurmcommons::main_conf_file :
    style        => 'keyval',
    data         => $slurmcommons::slurm_conf_options,
    exceptions   => ['Include'],
    require      => File["$slurmcommons::conf_dir_path"],
  }

  hpclib::print_config { $slurmcommons::part_conf_file :
    style        => 'linebyline',
    data         => $slurmcommons::partitions_conf,
    require      => File["$slurmcommons::conf_dir_path"],
  }

}
