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

# Installs and configure ISC DHCP server
#
# @param my_address Current server IP Address
# @param peer_address Synchronisation peer Address
# @param bootmenu_url URL to use in the bootmenu entries
# @param ipxebin DEPRECATED
# @param includes Hash describing `::iscdhcp::include` resources to create
# @param dhcp_config Default value for `dhcp_config` parameter of `includes`
# @param packages List of packages to install
# @param packages_ensure Target state for `packages`, `present` or `latest`
#           (default: `present`)
# @param config_file Path of the main configuration file (default:
#           '/etc/dhcp/dhcpd.conf')
# @param global_options Array of options set globally in the main configuration
#           file.
# @param sharednet Hash describing options for the shared net
# @param default_file Path of the file giving default environment for the
#         service (sysconfig or default).
# @param default_options Content of `default_file` as an array of lines.
# @param service Service Name
# @param service_ensure Target state for the service (default: '')
# @param systemd_config_file Systemd unit file path for the service
# @param systemd_config_options Systemd unit file content for the service,
#           this parameter is not merged with the default.
class iscdhcp (

  $my_address,
  $boot_params,
  $peer_address               = $iscdhcp::params::peer_address,
  $bootmenu_url               = $iscdhcp::params::bootmenu_url,
  $ipxebin                    = $iscdhcp::params::ipxebin,
  $includes                   = $iscdhcp::params::includes,
  $dhcp_config                = $iscdhcp::params::dhcp_config,
  $packages                   = $iscdhcp::params::packages,
  $packages_ensure            = $iscdhcp::params::packages_ensure,
  $config_file                = $iscdhcp::params::config_file,
  $global_options             = $iscdhcp::params::global_options,
  $sharednet                  = $iscdhcp::params::sharednet,
  $default_file               = $iscdhcp::params::default_file,
  $default_options            = $iscdhcp::params::default_options,
  $service                    = $iscdhcp::params::service,
  $service_ensure             = $iscdhcp::params::service_ensure,
  $systemd_config_file        = $iscdhcp::params::systemd_config_file,
  $systemd_config_options     = $iscdhcp::params::systemd_config_options,
) inherits iscdhcp::params {

  validate_string($my_address)
  validate_string($peer_address)
  validate_string($bootmenu_url)
  validate_string($ipxebin)
  validate_hash($includes)
  validate_hash($dhcp_config)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_array($global_options)
  validate_hash($sharednet)
  validate_absolute_path($default_file)
  validate_array($default_options)
  validate_string($service)
  validate_string($service_ensure)
  validate_absolute_path($systemd_config_file)
  validate_hash($systemd_config_options)
  validate_hash($boot_params)

  anchor { 'iscdhcp::begin': } ->
  class { '::iscdhcp::install': } ->
  class { '::iscdhcp::config': } ~>
  class { '::iscdhcp::service': }
  anchor { 'iscdhcp::end': }

}
