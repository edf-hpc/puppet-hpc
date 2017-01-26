class profiles::monitoring::cron {

	$cron_file = hiera('profiles::monitoring::cron::cron_file')
	$cron_source = hiera('profiles::monitoring::cron::cron_source')
	class { '::icinga2::cron':
		cron_file    => $cron_file,
		cron_source => $cron_source,
	}
}
