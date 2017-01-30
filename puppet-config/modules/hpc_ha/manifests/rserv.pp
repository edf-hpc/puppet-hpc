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

# A real server definition for the keepalived virtual server feature
#
# A real server is the backend of a virtual server. The real_hosts hash is
# used to provide an association between the name of the resource and the
# actual hostname to use
#
# Example:
# ```
# real_hosts => {
#   'clservice1' => 'wanclservice1',
#   'clservice2' => 'wanclservice2',
#   'clservice3' => 'wanclservice3',
# }
# ```
#
# @param virtual_server IP address of the virtual server
# @param port Port to check
# @param network  DEPRECATED Unused
# @param options Options to set on the check
# @param real_hosts Hash of all the real hosts
# @param real_host The real hostname to check
define hpc_ha::rserv (
  $virtual_server,
  $port,
  $network,
  $options    = undef,
  $real_hosts = {},
  $real_host  = undef,
) {

  $_name = regsubst($name, '[:\/\n]', '')

  validate_integer($port)

  if $real_host {
    $host = $real_host
  } else {
    $host = $real_hosts[$_name]
  }

  $real_server_ip_address = $::hostfile[$host]
  if $real_server_ip_address == '' {
    fail("Could not find an IP address in hostfile for host '${host}'")
  }

  validate_ip_address($real_server_ip_address)

  ::keepalived::lvs::real_server { $_name:
    virtual_server => $virtual_server,
    ip_address     => $real_server_ip_address,
    port           => $port,
    options        => $options,
  }

}
