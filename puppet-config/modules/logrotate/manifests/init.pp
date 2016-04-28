#
class logrotate (
  $ensure            = present,
  $hieramerge        = false,
  $manage_cron_daily = true,
  $package           = 'logrotate',
  $rules             = {},
  $config            = undef,
) {

  include ::logrotate::install
  include ::logrotate::config
  include ::logrotate::defaults
  include ::logrotate::rules

  anchor{'logrotate_begin':}->
  Class['::logrotate::install']->
  Class['::logrotate::config']->
  Class['::logrotate::defaults']->
  Class['::logrotate::rules']->
  anchor{'logrotate_end':}

}
