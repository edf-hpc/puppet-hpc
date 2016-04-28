class munge::config {

  file { $munge::auth_key_path :
    ensure => directory,
  }

  file { $munge::auth_key_name :
    content => decrypt($munge::auth_key_source, $munge::decrypt_passwd),
    mode    => $munge::auth_key_mode,
    owner   => $munge::auth_key_owner,
    require => File[$munge::auth_key_path],
  }
}
