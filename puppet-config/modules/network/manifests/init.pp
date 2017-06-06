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

# Configure the network on this host
#
# @param install_manage  Public class manages the installation (default: true)
# @param packages_manage Public class installs the packages (default: true)
# @param packages List of packages to install for networks (default: [])
# @param utils_packages Array of network utilities package names
# @param bonding_packages List of packages to install to use bonding
# @param bridge_packages List of packages to install to use bridges
# @param packages_ensure Target state for the packages (default: 'latest')
# @param config_manage Public class manages the configuration (default: true)
# @param config_file Path of the main network configuration file
# @param defaultgw IP Address of the default gateway
# @param fqdn Fully Qualified Domain Name of this host
# @param routednet Hash of direct routes for this host (default: {})
# @param hostname_augeas_path Augeas path of the file with the hostname
# @param hostname_augeas_change Augeas rule to apply to change the hostname
# @param bonding_options Hash with the bonding configuration for this host
# @param bridge_options Hash with the bridges configuration for this host
# @param ib_mtu MTU for the IPoIB network (default: '65520')
# @param ib_mode Mode for IPoIB, 'connected' or 'datagram' (default: 'connected')
# @param eth_no_offload_ifs Array of Ethernet interfaces on which offloading
#          should be explicitely disabled (default: [])
# @param service_manage Public class manages the service (default: true)
# @param service_name network manager service name (default: 'networking')
# @param service_ensure network manager service state (default: 'running')
# @param service_enable activation of network manager service at boottime
#                       (default: true)
class network (
  $install_manage         = $::network::params::install_manage,
  $packages_manage        = $::network::params::packages_manage,
  $packages               = [],
  $bonding_packages       = $::network::params::bonding_packages,
  $bridge_packages        = $::network::params::bridge_packages,
  $utils_packages         = $::network::params::utils_packages,
  $packages_ensure        = $::network::params::packages_ensure,
  $config_manage          = $::network::params::config_manage,
  $config_file            = $::network::params::config_file,
  $defaultgw,
  $fqdn,
  $routednet              = $::network::params::routednet,
  $hostname_augeas_path   = $::network::params::hostname_augeas_path,
  $hostname_augeas_change = $::network::params::hostname_augeas_change,
  $bonding_options        = $::network::params::bonding_options,
  $bridge_options         = $::network::params::bridge_options,
  $ib_mtu                 = $::network::params::ib_mtu,
  $ib_mode                = $::network::params::ib_mode,
  $eth_no_offload_ifs     = $::network::params::eth_no_offload_ifs,
  $service_manage         = $::network::params::service_manage,
  $service_name           = $::network::params::service_name,
  $service_ensure         = $::network::params::service_ensure,
  $service_enable         = $::network::params::service_enable,
) inherits network::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($config_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_array($bonding_packages)
    validate_array($bridge_packages)
    validate_string($packages_ensure)
    # merge bonding, bridge, utils and base packages
    $_base_packages = concat($bonding_packages, $bridge_packages)
    $_utils_packages = concat($_base_packages, $utils_packages)
    $_packages = concat($_utils_packages, $packages)
  }

  if $config_manage {
    validate_string($defaultgw)
    validate_hash($routednet)
    validate_string($hostname_augeas_path)
    validate_string($hostname_augeas_change)
    validate_absolute_path($config_file)
    validate_hash($bonding_options)
    validate_hash($bridge_options)
    validate_integer($ib_mtu)
    validate_string($ib_mode)
    validate_array($eth_no_offload_ifs)

    if $::osfamily == 'RedHat' and size($eth_no_offload_ifs) > 0 {
      warning("RedHat OS family does not supports the eth_no_offload_ifs parameter. It will be ignored (${eth_no_offload_ifs})")
    }
  }

  if $service_manage {
    validate_string($service_name)
    validate_string($service_ensure)
    validate_bool($service_enable)
  }

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'network::begin': } ->
  class { '::network::install': } ->
  class { '::network::config': } ~>
  class { '::network::service': } ->
  anchor { 'network::end': }

}
