class profiles::jobsched::submit {
  include ::slurmcommons
  include ::munge

  package{ [
    "slurm-llnl-generic-scripts-plugin",
  ]: }
}
