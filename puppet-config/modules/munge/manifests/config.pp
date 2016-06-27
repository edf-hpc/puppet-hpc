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

class munge::config {

  file { $munge::auth_key_path :
    ensure => directory,
  }

  file { $munge::auth_key_name :
    content => decrypt($munge::auth_key_source, $munge::decrypt_passwd),
    mode    => $munge::auth_key_mode,
    owner   => $munge::auth_key_owner,
    require => File[$munge::auth_key_path],
  }
}
