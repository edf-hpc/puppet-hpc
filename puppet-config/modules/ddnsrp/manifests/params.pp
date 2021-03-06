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

class ddnsrp::params {

  $install_manage  = true
  $packages_manage = true
  $packages        = ['ddn-ibsrp', 'ddn-udev', 'srptools']
  $packages_ensure = 'latest'

  case $::osfamily {
    'RedHat': {
      $init_file = '/etc/rc.d/init.d/ddn-ibsrp'
    }
    'Debian': {
      $init_file = '/etc/init.d/ddn-ibsrp'
    }
    default: {
      error("module does not support OS family ${::osfamily}")
    }
  }
  $init_src        = undef

  $config_manage   = true
  $module_opts     = [ 'options ib_srp srp_sg_tablesize=255' ]

  $service_manage  = true
  $service_name    = 'ddn-ibsrp'
  $service_ensure  = 'running'
  $service_enable  = true

}
