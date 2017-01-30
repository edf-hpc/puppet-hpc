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

# Configure libvirt daemon
#
# @param packages List of packages to install
# @param packages_ensure Target state for packages (default: 'installed')
# @param service Service name for libvirtd
# @param service_ensure Target state for service (default: 'running')
# @param service_enable Start service on boot (default: true)
# @param config_file Path of main configuration file (default: '/etc/libvirt/libvirtd.conf')
# @param config_options Hash with the content of `config_file`
class libvirt (
  $packages        = $::libvirt::params::packages,
  $packages_ensure = $::libvirt::params::packages_ensure,
  $service         = $::libvirt::params::service,
  $service_ensure  = $::libvirt::params::service_ensure,
  $service_enable  = $::libvirt::params::service_enable,
  $config_file     = $::libvirt::params::config_file,
  $config_options  = {},
) inherits libvirt::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_string($service)
  validate_string($service_ensure)
  validate_bool($service_enable)
  validate_absolute_path($config_file)
  validate_hash($config_options)

  $_config_options = merge ($::libvirt::params::config_options_defaults, $config_options)

  anchor { 'libvirt::begin': } ->
  class { '::libvirt::install': } ->
  class { '::libvirt::config': } ->
  class { '::libvirt::service': } ->
  anchor { 'libvirt::end': }

  Class['::libvirt::service'] -> Libvirt::Secret <| |> -> Libvirt::Pool <| |>
  Class['::libvirt::service'] -> Libvirt::Network <| |>
}
