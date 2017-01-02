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

# OpenLDAP replica setup script
# 
# @param make_replica_script Path of the script to generate the replica
# @param make_replica_script_source file source for the replica script
# @param directory_source hpclib ``decrypt()`` base directory for the
#          encrypted LDIF file
# @param ldif_directory LDIF file destination directory
# @param ldif_file LDIF file basename (not absolute path)
# @param decrypt_passwd Password to use with hpclib ``decrypt()`` function
class openldap::replica (
  $make_replica_script        = $openldap::params::make_replica_script,
  $make_replica_script_source = $openldap::params::make_replica_script_source,
  $directory_source           = $openldap::params::directory_source,
  $ldif_directory             = $openldap::params::ldif_directory,
  $ldif_file                  = $openldap::params::ldif_file,
  $decrypt_passwd             = $openldap::params::decrypt_passwd,
) inherits openldap {

  validate_absolute_path($make_replica_script)
  validate_absolute_path($ldif_directory)
  validate_string($decrypt_passwd)

  file { $ldif_directory :
    ensure => 'directory',
  }

  file { $make_replica_script :
    source  => $make_replica_script_source,
    require => Package[$::openldap::packages],
    mode    => '0700',
    owner   => 'root',
  }

  file { "${ldif_directory}/${ldif_file}" :
    content => decrypt("${directory_source}/${ldif_file}.enc", $decrypt_passwd),
    require => File[$ldif_directory],
    mode    => '0600',
    owner   => 'root',
  }

}
