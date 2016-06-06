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

class certificates::config inherits certificates {

  file { $certificates_directory :
    ensure => 'directory',
    owner  => $certificates_owner,
  }

  file { "${certificates_directory}/${certificate_file}" :
    ensure  => present,
    content => decrypt("${directory_source}/${certificate_file}.enc", $decrypt_passwd),
    require => File[$certificates_directory],
    mode    => '0600',
    owner   => $certificates_owner,
  }

  file { "${certificates_directory}/${key_file}" :
    ensure  => present,
    content => decrypt("${directory_source}/${key_file}.enc", $decrypt_passwd),
    require => File[$certificates_directory],
    mode    => '0600',
    owner   => $certificates_owner,
  }
}
