class icinga2::notif ($notif_script_conf, $notif_script_conf_src, $decrypt_password) {

  validate_absolute_path($notif_script_conf)
  validate_string($notif_script_conf_src)
  validate_string($decrypt_password)

  file { $notif_script_conf:
    content => decrypt($notif_script_conf_src, $decrypt_password),
    owner   => $::icinga2::user,
    group   => $::icinga2::user,
    mode    => '0400',
    require => $packages_resources,
  }
}
