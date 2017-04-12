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

# Setup Keepalive VIPs and supporting scripts
#
# This class permits to setup keepalive VIP and then attach scripts to the
# state changes of these VIPs.
#
# @param default_notify_script A generic script path to be called by
#           default for all VIPs
# @param vips Hash describing `hpc_ha::vip` resources
# @param vip_notify_scripts Hash describing `hpc_ha::vip_notify_script`
#           resources
# @param service_manage Does keepalived module manage the service (default:
#                       true)
# @param service_state Target keepalived systemd service state, only used when
#                      service_manage is false (default: 'enabled')
class hpc_ha (
  $default_notify_script = $::hpc_ha::params::default_notify_script,
  $vips                  = undef,
  $vip_notify_scripts    = undef,
  $vservs                = undef,
  $options               = $::hpc_ha::params::options,
  $service_manage        = $::hpc_ha::params::service_manage,
  $service_state         = $::hpc_ha::params::service_state,
) inherits hpc_ha::params {

  validate_bool($service_manage)
  validate_string($service_state)

  class { '::keepalived':
    service_manage => $service_manage,
  }

  anchor { 'hpc_ha::begin': } ->
  class { '::hpc_ha::install': } ->
  class { '::hpc_ha::config': } ->
  class { '::hpc_ha::service': } ->
  anchor { 'hpc_ha::end': }

  ::Hpc_ha::Vip_notify_script<| |> -> Class['::keepalived::service']

}
