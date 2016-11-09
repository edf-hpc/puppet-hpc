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

# Setup clara
#
# ## Hiera
# * `profiles::clara::repos`
# * `profiles::clara::ssl_directory_source`
# * `profiles::clara::certificates_directory`
# * `profiles::clara::certificate_file`
# * `profiles::clara::key_file`

class profiles::clara::base {

  # Hiera lookups 
  $directory_source       = hiera('profiles::clara::ssl_directory_source')
  $certificates_directory = hiera('profiles::clara::certificates_directory')
  $certificate_file       = hiera('profiles::clara::certificate_file')
  $key_file               = hiera('profiles::clara::key_file')
  $decrypt_passwd         = hiera('profiles::clara::decrypt_passwd')

  class { '::clara':
    repos_options => hiera_hash('profiles::clara::repos'),
  }

  file { $certificates_directory :
    ensure => 'directory',
  }
  file { "${certificates_directory}/${certificate_file}" :
    ensure  => present,
    content => decrypt("${directory_source}/${certificate_file}.enc", $decrypt_passwd),
    require => File[$certificates_directory],
    mode    => '0600',
  }
  file { "${certificates_directory}/${key_file}" :
    ensure  => present,
    content => decrypt("${directory_source}/${key_file}.enc", $decrypt_passwd),
    require => File[$certificates_directory],
    mode    => '0600',
  }

}
