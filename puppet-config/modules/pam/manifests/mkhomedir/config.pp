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

class pam::mkhomedir::config inherits pam::mkhomedir {

  file { $::pam::mkhomedir::mkhomedir_file :
    source    => $::pam::mkhomedir::mkhomedir_source,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    subscribe => Package[$::pam::mkhomedir::packages]
  }

  augeas { "pam_mkhomedir_common_session":
    context => "/files/etc/pam.d/common-session",
    onlyif => 'match *[module="pam_python.so"] size == 0',
    changes => [
      "set *[module = 'pam_mkhomedir_calibre.so']/module 'pam_python.so'",
      "set *[module = 'pam_python.so']/argument[1] '$::pam::mkhomedir::mkhomedir_file'",
    ],
  }

  augeas { "pam_mkhomedir_common_session_noninteractive":
    context => "/files/etc/pam.d/common-session-noninteractive",
    onlyif => 'match *[module="pam_python.so"] size == 0',
    changes => [
      "set *[module = 'pam_mkhomedir_calibre.so']/module 'pam_python.so'",
      "set *[module = 'pam_python.so']/argument[1] '$::pam::mkhomedir::mkhomedir_file'",
    ],
  }

}
