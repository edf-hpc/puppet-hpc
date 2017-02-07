##########################################################################
#  Puppet HPC profile for neos web resources                             #
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

# Neos web resources
#
# This include paraview server configuration (`neos.pvsc`)
#
# ## Hiera
# * `profiles::neos::config_options` (`hiera_hash`) Import neos configuration
#   to get some parameters
class profiles::neos::web {
  $neos_options = hiera_hash('profiles::neos::config_options')
  class { '::neos::web':
    neos_options => $neos_options,
  }
}
