#
class pam::params {

  $pam_modules_config_dir = '/usr/share/pam-configs'                
  $pam_ssh_config         = '/etc/pam.d/sshd'

  $access_config          = '/etc/security/access.conf'
  $access_config_opts     = ''
  
  $packages_ensure        = 'present'
  case $::osfamily {
    'Debian' : {
      $packages           = ['libpam-cracklib', 'libpam-modules']
      $access_exec        = "/bin/sed -i \"s/# account  required     pam_access.so/account  required     pam_access.so/g\" ${pam_ssh_config}"
    }
    'RedHat' : {
      $packages           = ['pam']
      $access_exec        = 'authconfig --enablepamaccess --update'
    }
    default : {}
  }

} 
