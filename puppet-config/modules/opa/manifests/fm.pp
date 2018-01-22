##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2018 EDF S.A.                                      #
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
#                        ['opa-fm'])
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
# @param priority        Hash of priority (default: {})
# @param shorttermhistory_enable boolean to Enable the ShortTermHistory
#          feature (default: true)
# @param ipoib_mcgroup_mtu MTU in bytes of the MulticastGroup used by IPoIB
#          (default: 2048)
# @param ipoib_mcgroup_rate String representing the rate of the MulticastGroup
#          used by IPoIB (default: '25g')

class opa::fm (
  $packages                = $::opa::fm::params::packages,
  $packages_ensure         = $::opa::fm::params::packages_ensure,
  $service                 = $::opa::fm::params::service,
  $service_ensure          = $::opa::fm::params::service_ensure,
  $service_enable          = $::opa::fm::params::service_enable,
  $config_file             = $::opa::fm::params::config_file,
  $config_source           = $::opa::fm::params::config_source,
  $fe_enable               = $::opa::fm::params::fe_enable,
  $fe_sslsecurity          = $::opa::fm::params::fe_sslsecurity,
  $devicegroups            = $::opa::fm::params::devicegroups,
  $pmportgroups            = $::opa::fm::params::pmportgroups,
  $priority                = $::opa::fm::params::priority,
  $shorttermhistory_enable = $::opa::fm::params::shorttermhistory_enable,
  $ipoib_mcgroup_mtu       = $::opa::fm::params::ipoib_mcgroup_mtu,
  $ipoib_mcgroup_rate      = $::opa::fm::params::ipoib_mcgroup_rate,
) inherits opa::fm::params {

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
  validate_hash($priority)
  validate_bool($shorttermhistory_enable)
  validate_integer($ipoib_mcgroup_mtu)
  validate_string($ipoib_mcgroup_rate)


  anchor { 'opa::fm::begin': } ->
  class { '::opa::fm::install': } ->
  class { '::opa::fm::config': } ~>
  class { '::opa::fm::service': } ->
  anchor { 'opa::fm::end': }
}
