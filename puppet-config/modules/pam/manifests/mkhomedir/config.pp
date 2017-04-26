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

  # The pam entry is also written by pam-auth-update, so we make sure it
  # is written in the pam-auth-update block to avoid a double entry.

  pam { 'pam_mkhomedir_common_session':
    ensure    => present,
    provider  => augeas,
    service   => 'common-session',
    type      => 'session',
    control   => 'required',
    module    => 'pam_python.so',
    arguments => concat([ $::pam::mkhomedir::mkhomedir_file ],
                        $::pam::mkhomedir::mkhomedir_args),
    position  => 'before #comment[ . = "end of pam-auth-update config" ]'
  }

  pam {'pam_mkhomedir_common_session_noninteractive':
    ensure    => present,
    provider  => augeas,
    service   => 'common-session-noninteractive',
    type      => 'session',
    control   => 'required',
    module    => 'pam_python.so',
    arguments => concat([ $::pam::mkhomedir::mkhomedir_file ],
                        $::pam::mkhomedir::mkhomedir_args),
    position  => 'before #comment[ . = "end of pam-auth-update config" ]'
  }

  Package<| |> -> Pam['pam_mkhomedir_common_session']
  Package<| |> -> Pam['pam_mkhomedir_common_session_noninteractive']

}
