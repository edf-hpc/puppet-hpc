class profiles::monitoring::admin {

  $cron_file = hiera('profiles::monitoring::admin::cron_file')
  $cron_source = hiera('profiles::monitoring::admin::cron_source')
  $conf_check_file = hiera('profiles::monitoring::admin::conf_check_file')
  $conf_check_source = hiera('profiles::monitoring::admin::conf_check_source')
  $pass_file = hiera('profiles::monitoring::admin::pass_file')
  $pass_source = hiera('profiles::monitoring::admin::pass_source')
  $decrypt_password = hiera('icinga2::decrypt_passwd')
  $node_cfg = hiera('profiles::monitoring::admin::node_cfg')
  class { '::icinga2::admin':
    node_cfg => $node_cfg,
    cron_file   => $cron_file,
    cron_source => $cron_source,
    conf_check_file => $conf_check_file,
    conf_check_source => $conf_check_source,
    pass_file   => $pass_file,
    pass_source => $pass_source,
    decrypt_password => $decrypt_password,
  }
}
