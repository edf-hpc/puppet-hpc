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

# Install certificates on nodes for LDAP
#
# @param directory_source         Directory where certificates are stored in puppet config (default: 'puppet:///modules/certificates')
# @param certificates_directory   Directory where certificates are installed on node (default: '/etc/certificates')
# @param certificate_file         Name of certificate file (.crt) (default: 'cluster.crt')
# @param key_file                 Name of key file (.key) (default: 'cluster.key')
# @param certificates_owner       Certificate's owner (default: 'root')
# @param decrypt_passwd           Encoded password (default: 'password')

class certificates (
  $directory_source       = $certificates::params::directory_source,
  $certificates_directory = $certificates::params::certificates_directory,
  $certificate_file       = $certificates::params::certificate_file,
  $key_file               = $certificates::params::key_file,
  $certificates_owner     = $certificates::params::certificates_owner,
  $decrypt_passwd         = $certificates::params::decrypt_passwd,
) inherits certificates::params {

  validate_string($decrypt_passwd)
  validate_absolute_path($certificates_directory)
  validate_string($certificate_file)
  validate_string($key_file)
  validate_string($certificates_owner)
  validate_string($decrypt_passwd)

  class { '::certificates::config': }

}
