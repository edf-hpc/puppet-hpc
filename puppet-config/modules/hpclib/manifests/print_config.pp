define hpclib::print_config(
  $style,
  $data,
  $target     = $title,
  $separator  = '=',
  $comments   = '#',
  $mode       = '0644'
) {

  validate_string($style) 

  case $style {
    ini : {
      validate_hash($data)
      $conf_template = 'hpclib/conf_ini.erb'
    }
    ini_flat : { # No sections.
      validate_hash($data)
      $conf_template = 'hpclib/conf_ini_flat.erb'
    }
    keyval : {
      validate_hash($data)
      $conf_template = 'hpclib/conf_keyval.erb'
    }
    linebyline : {
      validate_array($data)
      $conf_template = 'hpclib/conf_line_by_line.erb'
    }
    default : {
      $conf_template = ''
    }
  }

  file { $target :
    content => template($conf_template),
    mode    => $mode,
  }

}
