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

class pam::slurm::params {

  $packages_ensure    = 'present'
  $packages           = ['libpam-slurm']
  $pamauthupdate_file = '/usr/share/pam-configs/slurm'
  $exec               = "/bin/sed -i 's/account.*\\[.*\\].*pam_slurm.so/account\\trequired\\tpam_slurm.so/g' ${pamauthupdate_file}"
  $condition          = "/bin/grep -q 'account.*\\[.*\\].*pam_slurm' ${pamauthupdate_file}"

}
