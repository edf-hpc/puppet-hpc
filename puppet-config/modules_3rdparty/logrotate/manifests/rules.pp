# apply user-defined rules
class logrotate::rules{

  $hieramerge = $::logrotate::hieramerge
  $rules      = $::logrotate::rules

  if $hieramerge {
    $_rules = hiera_hash('logrotate::rules', $rules)
  } else {
    $_rules = $rules
  }

  create_resources('logrotate::rule', $_rules)

}