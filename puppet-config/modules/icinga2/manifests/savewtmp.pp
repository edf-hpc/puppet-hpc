class icinga2::savewtmp ($cron_file, $cron_source) {

	validate_absolute_path($cron_file)
	validate_string($cron_source)
	file { [ $cron_file ]:
		content => hpc_source_file($cron_source),
	}
}
