class profiles::hardware::cpufreq {

  ## Hiera lookups

  #$default_options = hiera_hash('profiles::environment::cpufreq::default_options')

  # Pass config options as a class parameter
  class { '::cpufreq':
#    default_options => $default_options,
  }
}
