#
class profiles::sudo::base {

  ## Hiera lookups

  $sudo_config_options = hiera_array('profiles::sudo::sudo_config_opts')

  # Pass config options as a class parameter
  class { '::sudo':
    config_options => $sudo_config_options,
  }

}
