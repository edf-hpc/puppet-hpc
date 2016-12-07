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

# Deploys Intel OPA Fabric Manager
#
# @param packages        Array of packages to install (default:
#                        ['opa-fm', 'opa-fastfabric'])
# @param packages_ensure Target state for the packages (default: 'installed')
# @param service         Name of the service to manage (default:
#                        'opafm')
# @param service_ensure  Target state for the service (default: 'running')
# @param service_enable  The service starts at boot time (default: true)
# @param config_file     Absolute path to OPA FM XML configuration file
#                        (default: '/etc/opa/opafm.xml')
# @param config_source   Source URL for a full config file (default: undef)
# @param fe_enable       Enables FE (default: true)
# @param fe_sslsecurity  FE uses TLS/SSL connections (default: false)
# @param devicegroups    Hash of device groups definitions (default: {})
# @param pmportgroups    Hash of Performance Manager (PM) port groups
#                        definitions (default: {})
class opafm (
  $packages        = $::opafm::params::packages,
  $packages_ensure = $::opafm::params::packages_ensure,
  $service         = $::opafm::params::service,
  $service_ensure  = $::opafm::params::service_ensure,
  $service_enable  = $::opafm::params::service_enable,
  $config_file     = $::opafm::params::config_file,
  $config_source   = $::opafm::params::config_source,
  $fe_enable       = $::opafm::params::fe_enable,
  $fe_sslsecurity  = $::opafm::params::fe_sslsecurity,
  $devicegroups    = $::opafm::params::devicegroups,
  $pmportgroups    = $::opafm::params::pmportgroups,
) inherits opafm::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_string($service)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_absolute_path($config_file)
  validate_string($config_source)
  validate_bool($fe_enable)
  validate_bool($fe_sslsecurity)
  validate_hash($devicegroups)
  validate_hash($pmportgroups)

  anchor { 'opafm::begin': } ->
  class { '::opafm::install': } ->
  class { '::opafm::config': } ~>
  class { '::opafm::service': } ->
  anchor { 'opafm::end': }
}
