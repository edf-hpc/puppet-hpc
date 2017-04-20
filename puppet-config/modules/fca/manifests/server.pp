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

# Deploys fca service
#
# @param service_manage Public class manages the service state (default: true)
# @param service_name Name of the service to manage (default: 'fca')
# @param service_ensure Target state for the service (default: 'running')
# @param service_enable The service starts at boot time (default: true)
class fca::server (
  $service_manage          = $::fca::params::service_manage,
  $service_name            = $::fca::params::service_name,
  $service_ensure          = $::fca::params::service_ensure,
  $service_enable          = $::fca::params::service_enable,
) inherits fca::server::params {

  include ::fca

  if $service_manage {
    validate_string($service_name)
    validate_string($service_ensure)
    validate_bool($service_enable)
  }

  anchor { 'fca::server:begin': } ->
  class { '::fca::server::service': } ~>
  anchor { 'fca::server::end': }

}
