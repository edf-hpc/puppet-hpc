class profiles::monitoring::savewtmp {

  $cron_file = hiera('profiles::monitoring::savewtmp::cron_file')
  $cron_source = hiera('profiles::monitoring::savewtmp::cron_source')
  class { '::icinga2::savewtmp':
    cron_file   => $cron_file,
    cron_source => $cron_source,
  }
}
