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

# Configure the network on this host
#
# ## Bonding
#
# Bonding is configured by passing bonding options as a hash:
#
# ```
# 'bond0' => {
#   'slaves'  => [ 'eth0', 'eth1' ],
#   'options' => 'mode=active-backup primary=eth0',
# },
# 'bond1' => {
#   'slaves'  => [ 'eth2', 'eth3' ],
#   'options' => 'mode=active-backup primary=eth2',
# },
# ```
#
#
# ## Bridge
#
# Bridges are configured by passing bridge options as a hash. If the 
# bridged port does not exists in the netconfig fact, it will be added
# automatically when the configuration is written.
#
# ```
# network::bridge_options:
#    'br0':
#      'ports':
#         - 'eth0'
#      'description': 'administraton network on service and nas nodes'
#    'br2':
#      'ports':
#         - 'bond2'
#      'description': 'WAN network on service nodes'
# ```
#
# @param ib_enable       Enable infiniband stack installation and
#                        configuration
# @param routednet       Direct routes for this host, array of triplets:
#                        `<IP network address>@<network prefix length>@<device>`
#                        (default: [])
# @param mlx4load        Load the `mlx4` driver, 'yes'` or 'no'
#                        (default: 'yes')
# @param bonding_options Hash with the bonding configuration for this
#                        host, see above (default: {})
# @param bridge_options  Hash with the bridges configuration for this
#                        host, see above (default: {})
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
  $systemd_tmpfile             = $::network::params::systemd_tmpfile,
  $systemd_tmpfile_options     = $::network::params::systemd_tmpfile_options,
  $ifup_hotplug_service        = $::network::params::ifup_hotplug_service,
  $ifup_hotplug_service_file   = $::network::params::ifup_hotplug_service_file,
  $ifup_hotplug_service_link   = $::network::params::ifup_hotplug_service_link,
  $ifup_hotplug_service_exec   = $::network::params::ifup_hotplug_service_exec,
  $ifup_hotplug_service_params = $::network::params::ifup_hotplug_service_params,
  $ifup_hotplug_services       = $::network::params::ifup_hotplug_services,
  $ifup_hotplug_files          = $::network::params::ifup_hotplug_files,
  $ib_enable                   = $::network::params::ib_enable,
  $opa_enable                  = $::network::params::opa_enable,
  $ib_udev_rule_file           = $::network::params::ib_udev_rule_file,
  $ib_file                     = $::network::params::ib_file,
  $ib_rules                    = $::network::params::ib_rules,
  $ib_packages                 = $::network::params::ib_packages,
  $opa_packages                = $::network::params::opa_packages,
  $mlx4load                    = $::network::params::mlx4load,
  $irqbalance_options          = $::network::params::irqbalance_options,
  $ib_mtu                      = $::network::params::ib_mtu,
  $ib_mode                     = $::network::params::ib_mode,
  $ib_options                  = {},
  $packages                    = [],
) inherits network::params {

  validate_string($defaultgw)
  validate_array($routednet)
  validate_string($hostname_augeas_path)
  validate_string($hostname_augeas_change)
  validate_absolute_path($config_file)

  validate_absolute_path($systemd_tmpfile)
  validate_array($systemd_tmpfile_options)

  validate_string($ifup_hotplug_service)
  validate_absolute_path($ifup_hotplug_service_file)
  validate_absolute_path($ifup_hotplug_service_link)
  validate_string($ifup_hotplug_service_exec)
  validate_hash($ifup_hotplug_service_params)
  validate_hash($ifup_hotplug_services)
  validate_hash($ifup_hotplug_files)
  validate_absolute_path($ib_udev_rule_file)
  validate_absolute_path($ib_file)
  validate_hash($ib_rules)
  validate_string($mlx4load)
  validate_hash($ib_options)
  validate_bool($ib_enable)
  validate_bool($opa_enable)

  validate_hash($irqbalance_options)
  validate_hash($bonding_options)
  validate_hash($bridge_options)

  validate_integer($ib_mtu)
  validate_string($ib_mode)

  # Bring all the package sources together
  validate_array($ib_packages)
  validate_array($opa_packages)
  validate_array($bonding_packages)
  validate_array($bridge_packages)
  validate_array($packages)
  $_base_packages = concat($bonding_packages, $bridge_packages)
  if $ib_enable {
    $ibbonding_packages = concat($ib_packages, $_base_packages)
  } elsif $opa_enable {
    $ibbonding_packages = concat($opa_packages, $_base_packages)
  } else {
    $ibbonding_packages = $_base_packages
  }
  $_packages = concat($ibbonding_packages, $packages)

  # OpenIB options
  $mlx_options = {
    'mlx4_load'    => $mlx4load,
    'mlx4_en_load' => $mlx4load,
  }
  $_ib_options = merge(
    $::network::params::ib_options_defaults,
    $ib_options,
    $mlx_options
  )

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'network::begin': } ->
  class { '::network::install': } ->
  class { '::network::config': } ~>
  class { '::network::service': } ->
  anchor { 'network::end': }

}
