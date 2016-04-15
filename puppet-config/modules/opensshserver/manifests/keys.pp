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

class opensshserver::keys inherits opensshserver {
  
  file { $root_key_directory :
    ensure => directory,
  }

 file { "${root_key_directory}/${root_key}" :
    ensure  => present,
    content => decrypt("${rootkeys_directory_source}/${root_key}.enc", $decrypt_passwd),
    mode    => 0600,
    require => File[$root_key_directory],
  }

  file { "${root_key}.pub" :
    path    => "${root_key_directory}/${root_key}.pub",
    source  => "file://${rootkeys_directory_source}/${root_key}.pub",
    mode    => 0600,
    require => File[$root_key_directory],
  }

}
