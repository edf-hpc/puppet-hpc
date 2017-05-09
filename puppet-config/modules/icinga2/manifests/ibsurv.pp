class icinga2::ibsurv ($node_cfg, $cron_file, $cron_source, $getiberr_file, $getiberr_source, $managedb_file, $managedb_source, $createdb_file, $createdb_source) {
 
   if $hostname == $node_cfg {

	validate_absolute_path($cron_file)
	validate_string($cron_source)
	validate_absolute_path($getiberr_file)
	validate_string($getiberr_source)
	validate_absolute_path($managedb_file)
        validate_string($managedb_source)
	validate_absolute_path($createdb_file)
	validate_string($createdb_source)

	file { [ "/etc/ibsurv" ]:
                ensure => 'directory',
                mode   => '0750',
        }		

	file { [ "$cron_file" ] :
		content => hpc_source_file($cron_source),
	}

	file { [ "$getiberr_file" ] :
		content => hpc_source_file($getiberr_source),
 		mode   => '0750',
        }

	file { [ "$managedb_file" ] :
                content => hpc_source_file($managedb_source),
		mode   => '0750',
        }

	file { [ "$createdb_file" ] :
                content => hpc_source_file($createdb_source),
        }

   }
	
}
