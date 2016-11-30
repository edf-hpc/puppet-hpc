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

# Install and configures a DNS server
#
# The configured DNS server acts as an authoritative server and/or as
# recursive.
#
# # Config options
#
# The parameter `config_options` hash is merged with some defaults.
#   - 'directory'          => '/var/cache/bind'
#   - 'auth-nxdomain'      => 'no'
#   - 'listen-on-v6'       => 'none'
#   - 'dnssec-validation'  => 'auto'
#   - 'empty-zones-enable' => 'no'
#
# Other options are not supported.
#
# # Zones
#
# Zones are defined as an array of hash:
#
# ```
#   "cluster.hpc.example.com" =>  {
#        "type" => "master",
#        "entries" => [
#            {
#              "owner" => "@",
#              "proto" => "IN",
#              "type"  => "NS",
#              "data"  => "cladmin1.cluster.hpc.example.com."
#            },
#            {
#              "owner" => "@",
#              "proto" => "IN",
#              "type"  => "A",
#              "data"  => "127.0.0.1"
#            },
#            {
#              "owner" => "cladmin1",
#              "proto" => "IN",
#              "type"  => "A",
#              "data"  => "10.1.16.11"
#            }
#        ]
#    }
# ```
#
# This array holds the forward and reverse zones. Reverse zones are not
# generated automatically by this class. If you are using this module with
# hpc-config, you can use the `hpc_dns_zones` function of the `hpclib`
# module.
#
# # Virtual domain
#
# If a `virtual_domain` is provided, a zone of type `forward` is activated
# and configured to forward on a DNS server listening on 127.0.0.1 port 8600.
# This option is meant to be used and tested with a consul server.
#
# @param manage_packages Puppet should manage package installation (default:
#            true)
# @param packages Package list
# @param packages_ensure Should packages be installed, latest or absent.
# @param manage_services Should Puppet manage the services (default: true)
# @param services Services list
# @param services_ensure Should the services run or be stopped
# @param manage_config Should puppet manage the configuration (default: true)
# @param config_dir Config directory path (default: '/etc/bind')
# @param config_file Main options configuration file (default:
#           '/etc/bind/named.conf.options')
# @param local_file Local domains configuration file (default:
#           '/etc/bind/named.conf.local')
# @param virtual_domain Domain name of the 'virtual' (consul) domain.
#           (default: disabled)
# @param zone_defaults Hash of default options for zones
# @param config_options Hash of options for the DNS server
# @param zones Hash of zones (default: {})
class dns::server (
  $manage_packages = $::dns::server::params::manage_packages,
  $packages        = $::dns::server::params::packages,
  $packages_ensure = $::dns::server::params::packages_ensure,
  $manage_services = $::dns::server::params::manage_services,
  $services        = $::dns::server::params::services,
  $services_ensure = $::dns::server::params::services_ensure,
  $manage_config   = $::dns::server::params::manage_config,
  $config_dir      = $::dns::server::params::config_dir,
  $config_file     = $::dns::server::params::config_file,
  $local_file      = $::dns::server::params::local_file,
  $zone_defaults   = $::dns::server::params::zone_defaults,
  $virtual_domain  = $::dns::server::params::virtual_domain,
  $config_options  = {},
  $zones           = {},
) inherits dns::server::params {

  validate_bool($manage_packages)
  validate_array($packages)
  validate_string($packages_ensure)
  validate_bool($manage_services)
  validate_array($services)
  validate_string($services_ensure)
  validate_absolute_path($config_dir)
  validate_absolute_path($config_file)
  validate_absolute_path($local_file)
  validate_hash($zone_defaults)
  validate_hash($config_options)
  validate_hash($zones)

  if $manage_config {
    $_config_options = merge($::dns::server::params::config_options_default, $config_options)
  }

  anchor { 'dns::server::begin': } ->
  class { '::dns::server::install': } ->
  class { '::dns::server::config': } ->
  class { '::dns::server::service': } ->
  anchor { 'dns::server::end': }

}
