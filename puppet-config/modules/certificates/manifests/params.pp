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

class certificates::params {

#### Module variables


#### Defaults values

  $certificates_directory        = '/etc/certificates'
  $certificates_directory_source = 'puppet:///modules/certificates'
  $certificate_file              = 'cluster.crt'
  $key_file                      = 'cluster.key'
  $certificates_owner            = 'root'
  $decrypt_passwd                = 'password'
}
