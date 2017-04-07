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
# @param defaultgw IP Address of the default gateway
# @param fqdn Fully Qualified Domain Name of this host
# @param routednet Direct routes for this host, array of triplets:
#           `<IP network address>@<network prefix length>@<device>` (default: [])
# @param hostname_augeas_path Augeas path of the file with the hostname
# @param hostname_augeas_change Augeas rule to apply to change the hostname
# @param bonding_packages List of packages to install to use bonding
# @param bonding_options Hash with the bonding configuration for this host
# @param bridge_packages List of packages to install to use bridges
# @param bridge_options Hash with the bridges configuration for this host
# @param config_file Path of the main network configuration file
# @param ifup_hotplug_service ifup service name
# @param ifup_hotplug_service_file ifup service unit file path
# @param ifup_hotplug_service_link ifup service unit wants link path
# @param ifup_hotplug_service_exec Command to ifup all hotplug interfaces
# @param ifup_hotplug_service_params Content of the ifup service unit file
# @param ifup_hotplug_services Hash with the definition of service resource
#           for the ifup service
# @param ifup_hotplug_files Hash with the definition of file resource for the
#           ifup service wants link
# @param ib_mtu MTU for the IPoIB network (default: '65520')
# @param ib_mode Mode for IPoIB, 'connected' or 'datagram' (default: 'connected')
class network (
  $defaultgw,
  $fqdn,
  $routednet                   = $::network::params::routednet,
  $hostname_augeas_path        = $::network::params::hostname_augeas_path,
  $hostname_augeas_change      = $::network::params::hostname_augeas_change,
  $bonding_packages            = $::network::params::bonding_packages,
  $bonding_options             = $::network::params::bonding_options,
  $bridge_packages             = $::network::params::bridge_packages,
  $bridge_options              = $::network::params::bridge_options,
  $config_file                 = $::network::params::config_file,
  $ifup_hotplug_service        = $::network::params::ifup_hotplug_service,
  $ifup_hotplug_service_file   = $::network::params::ifup_hotplug_service_file,
  $ifup_hotplug_service_link   = $::network::params::ifup_hotplug_service_link,
  $ifup_hotplug_service_exec   = $::network::params::ifup_hotplug_service_exec,
  $ifup_hotplug_service_params = $::network::params::ifup_hotplug_service_params,
  $ifup_hotplug_services       = $::network::params::ifup_hotplug_services,
  $ifup_hotplug_files          = $::network::params::ifup_hotplug_files,
  $ib_mtu                      = $::network::params::ib_mtu,
  $ib_mode                     = $::network::params::ib_mode,
  $packages                    = [],
) inherits network::params {

  validate_string($defaultgw)
  validate_array($routednet)
  validate_string($hostname_augeas_path)
  validate_string($hostname_augeas_change)
  validate_absolute_path($config_file)

  validate_string($ifup_hotplug_service)
  validate_absolute_path($ifup_hotplug_service_file)
  validate_absolute_path($ifup_hotplug_service_link)
  validate_string($ifup_hotplug_service_exec)
  validate_hash($ifup_hotplug_service_params)
  validate_hash($ifup_hotplug_services)
  validate_hash($ifup_hotplug_files)

  validate_hash($bonding_options)
  validate_hash($bridge_options)

  validate_integer($ib_mtu)
  validate_string($ib_mode)

  validate_array($bonding_packages)
  validate_array($bridge_packages)
  validate_array($packages)

  # merge bonding, bridge and base packages
  $_base_packages = concat($bonding_packages, $bridge_packages)
  $_packages = concat($_base_packages, $packages)

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'network::begin': } ->
  class { '::network::install': } ->
  class { '::network::config': } ~>
  class { '::network::service': } ->
  anchor { 'network::end': }

}
