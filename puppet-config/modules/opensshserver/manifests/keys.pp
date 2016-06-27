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

  file { $opensshserver::root_key_directory :
    ensure => directory,
  }

  file { "${opensshserver::root_key_directory}/${opensshserver::root_key}" :
    ensure  => present,
    content => decrypt("${opensshserver::directory_source}/${opensshserver::root_key}.enc", $opensshserver::decrypt_passwd),
    mode    => '0600',
    require => File[$opensshserver::root_key_directory],
  }

  file { "${opensshserver::root_key}.pub" :
    path    => "${opensshserver::root_key_directory}/${opensshserver::root_key}.pub",
    source  => "file://${opensshserver::directory_source}/${opensshserver::root_key}.pub",
    mode    => '0600',
    require => File[$opensshserver::root_key_directory],
  }

}
