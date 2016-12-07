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

class complex::server::params {

  $install_manage  = true
  $packages_manage = true
  $packages        = ['complex-server-package']
  $packages_ensure = 'latest'
  $services_manage = true
  $services        = ['complex-server-service']
  $services_ensure = 'running'
  $services_enable = true
  $config_manage   = true
  $config_file     = '/etc/complex/server.conf'
  $config_options  = {
    'section1' => {
      'param1' => 'value1',
      'param2' => 'value2',
    },
    'section2' => {
      'param3' => 'value3',
      'param4' => 'value4',
    },
  }
  $user            = 'complex-server-user'

  # There is not any sane and secure possible default values for the following
  # params so it is better to not define them in this class.
  #   $password
}
