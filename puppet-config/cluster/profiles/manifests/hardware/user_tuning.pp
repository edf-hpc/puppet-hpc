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

# Host tuning for user nodes
#
# ## Hiera 
# * `profiles::hardware::user_tuning::config_file`
# * `profiles::hardware::user_tuning::config_options` (`hiera_hash`)
class profiles::hardware::user_tuning {

  ## Hiera lookups
  $config_file    = hiera('profiles::hardware::user_tuning::config_file')
  $config_options = hiera_hash('profiles::hardware::user_tuning::config_options')

  # Call to hpclib::sysctl 
  hpclib::sysctl { $config_file :
    config      => $config_options,
    sysctl_file => $config_file,
  }

}
