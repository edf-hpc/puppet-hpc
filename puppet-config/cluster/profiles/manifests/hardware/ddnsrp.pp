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

# Installs DDN infiniband SRP software components
#
# Relevant autolookups:
#
# @param ddnsrp::init_src    URL to an alternate init script for DDN SRP system
#                            service
# @param ddnsrp::module_opts Kernel module options
class profiles::hardware::ddnsrp {

  include ::ddnsrp

  # The DDN SRP software stack requires an OpenSM instance to manage the link to
  # the SAN but it manages this instance by itself, with its own init scripts.
  # Then, the service provided by the OpenSM package and manage by the opensm
  # module must be disabled and stopped.
  class { '::opensm':
    service_enable => false,
    service_ensure => 'stopped',
  }

}
