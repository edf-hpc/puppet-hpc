#
class profiles::access::base {

  ## Hiera lookups

  $access_config_opts = hiera_array('profiles::access::access_config_opts')

  # Pass config options as a class parameter
  include pam
  class { '::pam::access':
    access_config_opts => $access_config_opts,
  }
}
