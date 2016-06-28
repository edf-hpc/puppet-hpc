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

# Pam_access configuration with `passwd` command support
#
# ## Hiera 
# * `profiles::access::access_config_opts` (`hiera_array`)
class profiles::access::password {

  ## Hiera lookups

  $access_config_opts = hiera_array('profiles::access::access_config_opts')

  # Pass config options as a class parameter
  include pam
  class { '::pam::access':
    access_config_opts => $access_config_opts,
  }
  include pam::pwquality

}
