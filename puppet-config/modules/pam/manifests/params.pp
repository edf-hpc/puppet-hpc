#
class pam::params {

  $pam_modules_config_dir = '/usr/share/pam-configs'                
  $pam_ssh_config         = '/etc/pam.d/sshd'
  $pam_slurm_config       = '/etc/pam.d/common-account'

  $access_config          = '/etc/security/access.conf'
  $access_config_opts     = ''
  
  $packages_ensure        = 'present'
  case $::osfamily {
    'Debian' : {
      $packages           = ['libpam-cracklib', 'libpam-modules']
      $access_exec        = "/bin/sed -i \"s/# account  required     pam_access.so/account  required     pam_access.so/g\" ${pam_ssh_config}"
      $pam_slurm_package  = ['libpam-slurm']
      $pam_slurm_exec     = "/bin/sed -i 's/account.*\\[.*\\].*pam_slurm.so/account\\trequired\\tpam_slurm.so/g' ${pam_slurm_config}" 
      $pam_slurm_condition= "/bin/grep -q 'account.*\\[.*\\].*pam_slurm' ${pam_slurm_config}"
    }
    'RedHat' : {
      $packages           = ['pam']
      $access_exec        = 'authconfig --enablepamaccess --update'
    }
    default : {}
  }

} 
