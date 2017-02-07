class clearsel::server {

	$decrypt_password = hiera('clearsel::decrypt_password')
	$clearsel_source = hiera('clearsel::clearsel_source')

	file { [ "/etc/clearsel" ]:
		ensure => 'directory'
	}
	file { [ "/etc/clearsel/clearsel.conf" ]:
		ensure  => 'present',
		owner   => 'root',
		group   => 'root',
		mode    => '0400',
		content => decrypt($clearsel_source, $decrypt_password),
		require => File['/etc/clearsel'],
	}
}
