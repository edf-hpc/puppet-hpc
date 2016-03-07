class ntp::params {

  $config       = '/etc/ntp.conf'
  $package_list = [ 'ntp', 'ntpdate' ]
  $service_opts = {
    'NTPD_OPTS' => "'-4 -g'",
  }
  $preferred_servers = []
  $servers = [
    '0.debian.pool.ntp.org',
    '1.debian.pool.ntp.org',
    '2.debian.pool.ntp.org',
    '3.debian.pool.ntp.org',
  ]

  case $::osfamily {
    'Debian': {
      $service_name   = 'ntp'
      $default_config = '/etc/default/ntp'
    }
    'Redhat': {
      $service_name   = 'ntpd'
      $default_config = '/etc/sysconfig/ntpd'
    }
    default: {}
  }
}
