##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2016 EDF S.A.                                      #
#  Contact: CCN-HPC <dsp-cspit-ccn-hpc@edf.fr>                           #
#                                                                        #
#  This program is free software; you can redistribute in and/or         #
#  modify it under the terms of the GNU General Public License,          #
#  version 2, as published by the Free Software Foundation.              #
#  This program is distributed in the hope that it will be useful,       #
#  but WITHOUT ANY WARRANTY; without even the implied warranty of        #
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
#  GNU General Public License for more details.                          #
##########################################################################

class pam::params {

  $pam_modules_config_dir = '/usr/share/pam-configs'
  $pam_ssh_config         = '/etc/pam.d/sshd'
  $pam_slurm_config       = '/etc/pam.d/common-account'
  $pam_pwquality_config   = "${pam_modules_config_dir}/pwquality"

  $access_config          = '/etc/security/access.conf'
  $access_config_opts     = ''

  $packages_ensure        = 'present'
  case $::osfamily {
    'Debian' : {
      $packages                = ['libpam-modules']
      $access_exec             = "/bin/sed -i \"s/# account  required     pam_access.so/account  required     pam_access.so/g\" ${pam_ssh_config}"
      $pam_slurm_package       = ['libpam-slurm']
      $pam_slurm_exec          = "/bin/sed -i 's/account.*\\[.*\\].*pam_slurm.so/account\\trequired\\tpam_slurm.so/g' ${pam_slurm_config}"
      $pam_slurm_condition     = "/bin/grep -q 'account.*\\[.*\\].*pam_slurm' ${pam_slurm_config}"
      $pam_sss_package         = ['libpam-sss']
      $pam_pwquality_package   = ['libpam-pwquality']
      $pam_pwquality_exec      = 'pam-auth-update --package --force'

      $limits_pam_service      = 'common-session'
      $limits_module           = 'pam_limits.so'
      $limits_type             = 'session'
      $limits_control          = 'required'
      $limits_position         = 'after #comment[ . = "end of pam-auth-update config"]'
      $limits_rules_file       = '/etc/security/limits.d/puppet.conf'
    }
    'RedHat' : {
      $packages           = ['pam']
      $access_exec        = 'authconfig --enablepamaccess --update'
    }
    default : {}
  }

}
