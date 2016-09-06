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


# Set apt configuration
# 
# In a separate class to set the stage.
#
# @param sources APT sources as defined by `apt::sources`
# @param confs   APT configs as defined by `apt::conf`
class hpc_apt (
  $confs   = {},
  $sources = {},
) {
  include ::apt

  create_resources(apt::conf, $confs)
  create_resources(apt::source, $sources)
}
