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

class opafm (
  $packages        = $::opafm::params::packages,
  $packages_ensure = $::opafm::params::packages_ensure,
  $service         = $::opafm::params::service,
  $service_ensure  = $::opafm::params::service_ensure,
  $service_enable  = $::opafm::params::service_enable,
) inherits opafm::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_string($service)
  validate_string($service_ensure)
  validate_bool($service_enable)

  anchor { 'opafm::begin': } ->
  class { '::opafm::install': } ->
  class { '::opafm::service': } ->
  anchor { 'opafm::end': }
}
