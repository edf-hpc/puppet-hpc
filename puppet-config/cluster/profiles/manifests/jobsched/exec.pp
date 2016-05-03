class profiles::jobsched::exec {
  include ::slurmd
  include ::munge

  Class['::munge::service'] -> 
  Class['::slurmd::service']

  package{ [
    'slurm-llnl-generic-scripts-plugin',
  ]: }
}
