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
