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

class ipmi::params {

#### Module variables

  case $::osfamily {
    'Debian' : {
      $config_file          = '/etc/modules-load.d/ipmi.conf'
      $config_file_template = 'ipmi/modulesdeb.erb'
      $config_options       = [ 'ipmi_si', 'ipmi_devintf' ]
      $config_file_mode     = 0644
    }
    'RedHat' : {
      $config_file          = '/etc/sysconfig/modules/ipmi.modules'
      $config_file_template = 'tuning/modulesrhel.erb'
      $config_options       = [ 'ipmi_devintf' ]
      $config_file_mode     = 0750
    }
    default : {
      fail("${::osfamily} is not supported")
    }
  }
}
