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

class pam::mkhomedir::config inherits pam::mkhomedir {

  file { $::pam::mkhomedir::mkhomedir_file :
    source    => $::pam::mkhomedir::mkhomedir_source,
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    subscribe => Package[$::pam::mkhomedir::packages]
  }

  pam { 'pam_mkhomedir_common_session':
    ensure    => present,
    provider  => augeas,
    service   => 'common-session',
    type      => 'session',
    control   => 'required',
    module    => 'pam_python.so',
    arguments => $::pam::mkhomedir::mkhomedir_file,
    position  => 'after #comment[ . = "end of pam-auth-update config" ]',
}

  pam {'"pam_mkhomedir_common_session_noninteractive':
    ensure    => present,
    provider  => augeas,
    service   => 'common-session-noninteractive',
    type      => 'session',
    control   => 'required',
    module    => 'pam_python.so',
    arguments => $::pam::mkhomedir::mkhomedir_file,
    position  => 'after #comment[ . = "end of pam-auth-update config" ]',
  }

}
