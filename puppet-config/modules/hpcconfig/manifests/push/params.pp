#########################################################################
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

class hpcconfig::push::params {
  $packages                 = ['hpc-config-push']
  $packages_ensure          = 'latest'
  $config_file              = '/etc/hpc-config/push.conf'
  $config_options_defaults  = {
    'global' => {
      environment => 'production',
      version     => 'latest',
      destination => 'hpc-config',
    },
  }
  $eyaml_config_file        = '/root/.eyaml/config.yaml'
  $eyaml_config_options     = {
    'pkcs7_private_key' => '/etc/puppet/secure/keys/private_key.pkcs7.pem',
    'pkcs7_public_key'  => '/etc/puppet/secure/keys/public_key.pkcs7.pem',
  }

}
