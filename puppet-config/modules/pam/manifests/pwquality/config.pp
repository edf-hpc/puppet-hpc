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

class pam::pwquality::config inherits pam::pwquality {

  file { $::pam::pwquality::pamauthupdate_file :
    source    => 'puppet:///modules/pam/pwquality',
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    subscribe => Package[$pam::pwquality::packages]
  }

  exec { 'refresh common-password for pwquality':
    command     => '/usr/sbin/pam-auth-update --package --force',
    require     => File[$::pam::pwquality::pamauthupdate_file],
    subscribe   => File[$::pam::pwquality::pamauthupdate_file],
    refreshonly => true
  }

}
