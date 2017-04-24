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

# Replace the standard crontabs directory with a symbolic link
# Crontabs can be moved in a permanent directory as the nodes are all diskless
#
# # Relevant autolookup
#
# - `hpc_crontabs::crontabs_dir_destination` Target for the symbolic link
class profiles::environment::users_crontabs {
  include ::hpc_crontabs
}
