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

# Log server
#
# ## Hiera
# * `profiles::log::server::logrotate_rules`  Logrotate additional rules
#   (default: {})
# * `profiles::log::server::service_override` Hash of systemd service override
#   definition (default: {})
# * `profiles::log::server::listen_address` Address the syslog server
#     server will listen on, only works for UDP (default: '0.0.0.0')
class profiles::log::server {

  ## Hiera lookups

  $logrotate_rules = hiera_hash('profiles::log::server::logrotate_rules', {})
  $service_override = hiera_hash('profiles::log::server::service_override', {})
  $listen_address = hiera('profiles::log::server::listen_address', '0.0.0.0')
  if $listen_address == '0.0.0.0' {
    $listen_address_actual = undef
  } else {
    $listen_address_actual = $listen_address

    ## Sysctl setup
    # We need a sysctl to enable the ip_nonlocal_bind that will permit
    # carbon-c-relay to bind the VIP on the failover node
    kernel::sysctl { 'profiles_log_server':
      params => {
        'net.ipv4.ip_nonlocal_bind' => '1',
      },
    }
  }

  class { '::rsyslog::server':
    address => $listen_address_actual,
  }

  class { '::hpc_rsyslog::server':
    logrotate_rules  => $logrotate_rules,
    service_override => $service_override,
  }

  # server_dir may be an NFS-mounted directory. In order to avoid writing
  # logs in the void, ::rsyslog::server must not be configured and restarted
  # before NFS mount is ready.
  Mount <| tag == 'nfs' |> -> Class['::rsyslog::server']

}
