class admintemp {
	file { [ '/usr/local/sbin/manage-admin-temporaire' ]:
		source => 'puppet:///modules/admintemp/manage-admin-temporaire',
		ensure => file,
		owner => root,
		group => root,
		mode => 700,
	}
	$admin_temporaire_cron = hiera('admintemp::manage-admin-temporaire_cron')

	file { [ '/etc/cron.d/manage-admin-temporaire' ]:
		content => hpc_source_file($admin_temporaire_cron),
		ensure => file,
		owner => root,
		group => root,
		mode => 750,
	}
	group { [ 'admin-temporaire' ]:
		ensure => present,
		forcelocal => 'true',
	}
	$admin_temporaire_conf=hiera('admintemp::manage-admin-temporaire_conf')
        file { [ '/etc/manage-admin-temporaire.conf' ] :
                content => hpc_source_file($admin_temporaire_conf),
        }
}
