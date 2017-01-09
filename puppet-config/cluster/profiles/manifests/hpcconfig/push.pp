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

# Hpc-config-push setup 
#
# ## Relevant Autolookup
# * `hpcconfig::push::config_options`  Parameters used to build config file for hpc-config-push
# * `hpcconfig::push::eyaml_config_options`  Parameters used to build config file for eyaml
class profiles::hpcconfig::push {

# Install hpc-config-push
  class { '::hpcconfig::push':
  }

}
