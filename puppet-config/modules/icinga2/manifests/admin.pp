class icinga2::admin ($cron_file, $cron_source, $pass_file, $pass_source, $decrypt_password, $conf_check_file, $conf_check_source) {
	validate_absolute_path($cron_file)
	validate_string($cron_source)
	validate_absolute_path($conf_check_file)
	validate_string($conf_check_source)
	validate_absolute_path($pass_file)
	validate_string($pass_source)
	validate_string($decrypt_password)

	file { [ $cron_file ] :
		content => hpc_source_file($cron_source),
	}

	file { [ $conf_check_file ] :
                content => hpc_source_file($conf_check_source),
        }
	
	$dir=dirname("$pass_file")
	file { [ "$dir" ]:
		ensure => 'directory',
		mode   => '0755',
	}

	file { [ "$pass_file" ]:
		ensure  => 'present',
		owner   => 'root',
		group   => 'root',
		mode    => '0400',
		content => decrypt($pass_source, $decrypt_password),
	}
}
