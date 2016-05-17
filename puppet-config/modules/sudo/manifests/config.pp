#
class sudo::config inherits sudo {

  # Array concatenation (Can be simplified with future parser)  
  $array_to_concat = ['Defaults env_reset',$sudo::config_options]
  $final_config_options = flatten($array_to_concat)

  hpclib::print_config { $sudo::config_file :
    style   => 'linebyline',
    data    => $final_config_options,
    require => Package[$sudo::packages],
  }

}
