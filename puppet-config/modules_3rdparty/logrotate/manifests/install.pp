# make sure logrotate is installed
class logrotate::install{

  $ensure  = $::logrotate::ensure
  $package = $::logrotate::package

  case $ensure {
    'latest': { $_ensure = 'latest' }
    false,'absent': { $_ensure = 'absent' }
    default: { $_ensure = 'present' }
  }

  package { $package:
    ensure => $_ensure,
  }

}