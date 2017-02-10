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

# Setup sudo
#
# ## Hiera
# * `profiles::sudo::sudo_config_opts` Array of sudo config lines (default: [])
class profiles::sudo::base {

  ## Hiera lookups
  $sudo_config_options = hiera_array('profiles::sudo::sudo_config_opts', [])

  # Pass config options as a class parameter
  class { '::sudo':
    config_options => $sudo_config_options,
  }

}
