#
class pam::install inherits pam {

  package { $pam::packages :
    ensure => $pam::packages_ensure,
  }
 
  file { $pam::pam_modules_config_dir :
    ensure => 'directory',
  }

  file { $pam::pam_ssh_config :
    ensure => 'present',
  }

}
