class profiles::monitoring::admin {

  $cron_file = hiera('profiles::monitoring::admin::cron_file')
  $cron_source = hiera('profiles::monitoring::admin::cron_source')
  $pass_file = hiera('profiles::monitoring::admin::pass_file')
  $pass_source = hiera('profiles::monitoring::admin::pass_source')
  $decrypt_password = hiera('icinga2::decrypt_passwd')
  class { '::icinga2::admin':
    cron_file   => $cron_file,
    cron_source => $cron_source,
    pass_file   => $pass_file,
    pass_source => $pass_source,
    decrypt_password => $decrypt_password,
  }
}
