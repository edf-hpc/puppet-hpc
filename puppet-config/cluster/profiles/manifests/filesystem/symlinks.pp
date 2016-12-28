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

# Create symbolic links accross the filesystem from hiera
#
#
# Links are defined with a hash of the form:
#
# ```
#   '<source_path>':
#     target: '<target_path>'
# ```
#
# This profiles is reserved for symlinks created by the system
# administrator. Other profiles or module should create their own
# symlinks directly.
#
# ## Hiera
# * `profiles::filesystem::symlinks` (`hiera_hash`) Hash with the links
#       to create.
class profiles::filesystem::symlinks {

  # Hiera lookups
  $links = hiera_hash('profiles::filesystem::symlinks')

  class{ '::filesystem::symlinks':
    symlinks => $links,
    stage    => 'first',
  }


}
