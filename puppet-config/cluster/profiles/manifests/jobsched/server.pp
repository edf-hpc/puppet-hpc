class profiles::jobsched::server {
  include ::slurmdbd
  include ::slurmctld
  include ::munge
  
  Class['::munge::service'] ->
  Class['::slurmdbd::service'] ->
  Class['::slurmctld::service']

  package{ [
    'slurm-llnl-generic-scripts-plugin',
  ]: }
}
