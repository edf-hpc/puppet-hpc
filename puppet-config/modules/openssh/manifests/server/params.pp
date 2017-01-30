##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2017 EDF S.A.                                      #
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

class openssh::server::params {

  #### Module variables
  $packages_ensure = 'latest'
  $config_file     = '/etc/ssh/sshd_config'
  $augeas_context  = "/files/${config_file}"
  $service         = 'ssh'
  $service_ensure  = 'running'
  $service_enable  = true

  case $::osfamily {
    'Debian' : {
      $packages = [
        'ssh',
        'openssh-server',
      ]
    }
    'RedHat' : {
      $packages = [
        'openssh',
        'openssh-server',
      ]
    }
    default : {
      $packages = [
        'ssh',
        'openssh-server',
      ]
    }
  }
  #### Defaults values
  $config_augeas = [
    'set MaxStartups 8192',
    'set PermitRootLogin yes',
    'set X11UseLocalhost no',
  ]

  $cluster = 'cluster'

  # Example file in the `files/` directory, should obviously not be used in
  # production.
  $root_public_key = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDxPBL2D3+fW/GTjCpUI+kVAg6s1M8Z0lRRX35ecodrgz09X70tMFC2h9brXrY2557abUX3jy+0khEV81p24havY9Zi6+7rAqaB3ehCwIPTRT0vqCmHzWSOwK6WJbtur2xnXGvlwM/ngtE/RfUfbPU0Kvb6DG+kWedzi3stwyF4mRkOUahg2l0h+hKHHo46XJFI/bUfNP1ybFSAWYdkYP5Fy2pXK8JdUnYIp5wQIU6waeGUf/fEHPlyZC9fGWqygtSzOCXo3v7KQP9OLW9bupOuXi8zTt4fDKB9qQRjezt4sgnhG/yd/UwQupenIMh2m3DMAX2/e0+w6b1ORP8lzCpd'

  $hostkeys_dir             = '/etc/ssh'
  $host_private_key_rsa     = 'ssh_host_rsa_key'
  $host_public_key_rsa      = 'ssh_host_rsa_key.pub'
  $host_private_key_dsa     = 'ssh_host_dsa_key'
  $host_public_key_dsa      = 'ssh_host_dsa_key.pub'
  $host_private_key_ecdsa   = 'ssh_host_ecdsa_key'
  $host_public_key_ecdsa    = 'ssh_host_ecdsa_key.pub'
  $host_private_key_ed25519 = 'ssh_host_ed25519_key'
  $host_public_key_ed25519  = 'ssh_host_ed25519_key.pub'
  $hostkeys_source_dir      = 'openssh'

  $decrypt_password         = 'password'

}
