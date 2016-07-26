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

class slurmweb::params {

  #### Module variables
  $packages_ensure   = 'latest'
  $packages          = ['slurm-web-restapi', 'redis-server']
  $config_file       = '/etc/slurm-web/restapi.conf'
  $racks_file        = '/etc/slurm-web/racks.xml'
  $racks_file_source = 'puppet:///modules/slurmweb/racks.xml'
  
  #### Defaults values
  $decrypt_password  = 'password'
  $slurm_user        = 'slurm'
}
