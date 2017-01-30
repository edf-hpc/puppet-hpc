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

# SSH client default configuration
#
# ## Hiera
# * `profiles::openssh::client::identities` (`hiera_hash`)
#         Define identities to use for openssh clients on this node
class profiles::openssh::client_identities {
  $identities = hiera_hash('profiles::openssh::client::identities')
  create_resources(openssh::client::identity, $identities)
}
