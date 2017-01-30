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

# Create directories accross the filesystem from hiera
#
#
# Directories are defined with a hash of the form:
#
# ```
#   '<path>':
#     owner: 'root'
#     group: 'root'
#     mode:  '0755'
# ```
#
# This profiles is reserved for directories created by the system
# administrator. Other profiles or module should create their own
# directories directly.
#
# ## Hiera
# * `profiles::filesystem::directories` (`hiera_hash`) Hash with the dirs
#       to create.
class profiles::filesystem::directories {

  # Hiera lookups
  $dirs = hiera_hash('profiles::filesystem::directories')

  class{ '::filesystem::directories':
    directories => $dirs,
    stage       => 'first',
  }

}
