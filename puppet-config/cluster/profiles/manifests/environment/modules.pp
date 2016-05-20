class profiles::environment::modules {

  ## Hiera lookups

  $config_options = hiera('profiles::environment::modules::config_options')

  # Pass config options as a class parameter
  class { '::environment_modules':
    config_options => $config_options,
    rootdirmodules => $rootdirmodules,

  }
}
