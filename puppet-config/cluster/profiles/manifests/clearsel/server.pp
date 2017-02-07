class profiles::clearsel::server {
	$packages = [ 'clearsel' ]

	package { $packages :
		ensure => latest,
	}

	include ::clearsel::server

}

