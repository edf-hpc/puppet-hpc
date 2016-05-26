class tftp::config inherits tftp {

  hpclib::print_config { $tftp::config_file :
    style   => 'keyval',
    data    => $tftp::config_options,
    notify  => Service[$tftp::service],
  }

}
