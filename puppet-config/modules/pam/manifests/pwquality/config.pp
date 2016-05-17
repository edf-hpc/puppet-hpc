#
class pam::pwquality::config inherits pam::pwquality {

  file { $pam::pwquality::pam_pwquality_config :
    source    => 'puppet:///modules/pam/pwquality',
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    subscribe => Package[$pam::pwquality::pam_pwquality_package]
  }
  exec { [ 'refresh common-password' ]:
    command     => '/usr/sbin/pam-auth-update --package --force',
    require     => File["${pam::pwquality::pam_pwquality_config}"],
    subscribe   => File["${pam::pwquality::pam_pwquality_config}"],
    refreshonly => true
  }

}
