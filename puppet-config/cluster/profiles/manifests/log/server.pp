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

# Log server
#
# ## Hiera
# * `profiles::log::server::logrotate_rules`  Logrotate additional rules
#   (default: {})
# * `profiles::log::server::service_override` Hash of systemd service override
#   definition (default: {})
class profiles::log::server {

  ## Hiera lookups

  $logrotate_rules = hiera_hash('profiles::log::server::logrotate_rules', {})
  $service_override = hiera_hash('profiles::log::server::service_override', {})

  include ::rsyslog::server

  class { '::hpc_rsyslog::server':
    logrotate_rules  => $logrotate_rules,
    service_override => $service_override,
  }

  # server_dir may be an NFS-mounted directory. In order to avoid writing
  # logs in the void, ::rsyslog::server must not be configured and restarted
  # before NFS mount is ready.
  Mount <| tag == 'nfs' |> -> Class['::rsyslog::server']

}
