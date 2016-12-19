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
# * `profiles::log::server::server_dir`
# * `profiles::log::server::custom_config`
# * `profiles::log::server::logrotate_firstaction` Check command before
#     rotating the logs on disk (default: `undef`)
class profiles::log::server {

  ## Hiera lookups

  $server_dir    = hiera('profiles::log::server::server_dir')
  $custom_config = hiera('profiles::log::server::custom_config')
  $firstaction   = hiera('profiles::log::server::logrotate_firstaction', undef)

  # Pass config options as a class parameter
  class { '::rsyslog::server':
    server_dir    => $server_dir,
    custom_config => $custom_config,
  }
  logrotate::rule { 'remotelog':
    path          => "${server_dir}/*/*",
    compress      => true,
    missingok     => true,
    firstaction   => $firstaction,
    copytruncate  => true,
    create        => false,
    delaycompress => true,
    mail          => false,
    rotate        => '30',
    sharedscripts => true,
    size          => '5M',
    rotate_every  => day,
    postrotate    => 'invoke-rc.d rsyslog rotate > /dev/null',
  }

  # server_dir may be an NFS-mounted directory. In order to avoid writing
  # logs in the void, ::rsyslog::server must not be configured and restarted
  # before NFS mount is ready.
  Mount <| tag == 'nfs' |> -> Class['::rsyslog::server']

}
