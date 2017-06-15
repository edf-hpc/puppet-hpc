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

class ipmi::params {

  $install_manage  = true

  $packages_manage = true
  $packages_ensure = 'present'

  case $::osfamily {
    'Debian' : {
      $use_systemd_modules  = true
      $modules_load_name    = 'ipmievd'
      $config_options       = [ 'ipmi_si', 'ipmi_devintf' ]
      $packages             = [ 'ipmitool' ]
    }
    'RedHat' : {
      $use_systemd_modules  = false
      $config_file          = '/etc/sysconfig/modules/ipmi.modules'
      $config_file_template = 'ipmi/modulesrhel.erb'
      $config_options       = [ 'ipmi_devintf' ]
      $config_file_mode     = '0750'
      # Not tested
      $packages             = [
        'OpenIPMI',
        'ipmitool',
      ]
    }
    default : {
      fail("${::osfamily} is not supported")
    }
  }
}
