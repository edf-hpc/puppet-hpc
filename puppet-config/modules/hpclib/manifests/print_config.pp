define hpclib::print_config(
  $style,
  $data,
  $target          = $title,
  $separator       = '=',
  $comments        = '#',
  $mode            = '0644',
  $exceptions      = [],
  $excep_separator = ' '
) {

  validate_string($style) 
  validate_string($separator) 
  validate_string($comments) 
  validate_numeric($mode) 
  validate_array($exceptions) 
  validate_string($excep_separator) 
  $conf_template = 'hpclib/conf_template.erb'

  case $style {
    ini : {
      validate_hash($data)
    }
    ini_flat : { # No sections.
      validate_hash($data)
    }
    keyval : {
      validate_hash($data)
    }
    linebyline : {
      validate_array($data)
    }
    default : {
      fail("The ${style} style is not supported.")
    }
  }

  file { $target :
    content => template($conf_template),
    mode    => $mode,
  }

}
