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
class hpc_ha (
  $default_notify_script = $::hpc_ha::params::default_notify_script,
  $vips                  = undef,
  $vip_notify_scripts    = undef,
  $vservs                = undef,
  $options               = $::hpc_ha::params::options,
) inherits hpc_ha::params {
  include keepalived

  anchor { 'hpc_ha::begin': } ->
  class { '::hpc_ha::install': } ->
  class { '::hpc_ha::config': } ->
  class { '::hpc_ha::service': } ->
  anchor { 'hpc_ha::end': }

}
