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

class cpupower::params {

  #### Module variables
  $packages_ensure = 'latest'

  case $::osfamily {
    'RedHat': {
      $config_manage   = true
      $service_manage  = true
      $packages        = ['kernel-tools']
      $default_file    = '/etc/sysconfig/cpupower'
      $service         = 'cpupower'
      $service_ensure  = running
      $service_enable  = true
    }
    'Debian': {
      $config_manage   = false
      $service_manage  = false
      $packages        = ['linux-cpupower']
    }
    default: {
      fail("Unsupported OS Family '${::osfamily}', should be: 'Debian', 'Redhat'.")
    }
  }


  #### Defaults values
  $default_options = {
    'CPUPOWER_START_OPTS' => '"frequency-set -g performance"',
    'CPUPOWER_STOP_OPTS'  => '"frequency-set -g ondemand"'
  }

}
