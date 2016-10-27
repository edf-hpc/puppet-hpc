##########################################################################
#  Puppet paramsuration file                                             #
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

class pam::mkhomedir::params {

  $packages_ensure    = 'present'
  $packages           = ['libpam-python']
  $mkhomedir_file     = '/usr/share/pam/pam_mkhomedir.py'
  $mkhomedir_source   = 'puppet:///modules/pam/pam_mkhomedir.py'

}
