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

class pam::pwquality::config inherits pam::pwquality {

  file { $pam::pwquality::pam_pwquality_config :
    source    => 'puppet:///modules/pam/pwquality',
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    subscribe => Package[$pam::pwquality::pam_pwquality_package]
  }
  exec { [ 'refresh common-password' ]:
    command     => '/usr/sbin/pam-auth-update --package --force',
    require     => File["${pam::pwquality::pam_pwquality_config}"],
    subscribe   => File["${pam::pwquality::pam_pwquality_config}"],
    refreshonly => true
  }

}
