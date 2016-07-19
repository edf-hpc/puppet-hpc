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

# @param routednet Direct routes for this host, array of triplets:
#                  `<IP network address>@<network prefix length>@<device>`
#                  (default: [])
# @param mlx4load  Load the `mlx4` driver, 'yes'` or 'no' (default: 'yes')
class network (
  $defaultgw,
  $routednet                   = $::network::params::routednet,
  $hostname_augeas_path        = $::network::params::hostname_augeas_path,
  $hostname_augeas_change      = $::network::params::hostname_augeas_change,
  $bonding_packages            = $::network::params::bonding_packages,
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
  $ib_udev_rule_file           = $::network::params::ib_udev_rule_file,
  $ib_file                     = $::network::params::ib_file,
  $ib_rules                    = $::network::params::ib_rules,
  $ib_packages                 = $::network::params::ib_packages,
  $mlx4load                    = $::network::params::mlx4load,
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

  # Bring all the package sources together
  validate_array($ib_packages)
  validate_array($bonding_packages)
  validate_array($packages)
  # can be done in one call with later stdlib versions
  $ibbonding_packages = concat($ib_packages, $bonding_packages)
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
