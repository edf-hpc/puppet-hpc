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

# Log collection on clients
#
# There is a main log forward to a server, typically a machine with the
# log::server profile. The main forward is controlled with the `protocol`,
# `host` and `port` hiera variables.
#
# Supplementary destination can be configured with the remote_servers
# hiera array. This is an array of hashes with `protocol`, `host` and
# `port` values. It can also include a `pattern` value that filters what
# is sent to this remote server. The syntax uses the rsyslog "traditional"
# selector syntax (`facility.severity[;facility.severity...]`). Default is
# `*.*`.
#
# ## Hiera
# * `profiles::log::client::protocol`
# * `profiles::log::client::host`
# * `profiles::log::client::port`
# * `profiles::log::client::remote_servers` (`hiera_array`) Array of hashes
class profiles::log::client {

  ## Hiera lookups
  $protocol       = hiera('profiles::log::client::protocol')
  $host           = hiera('profiles::log::client::host')
  $port           = hiera('profiles::log::client::port')
  $remote_servers = hiera_array('profiles::log::client::remote_servers')

  # Permits to change the config through hiera
  include ::systemd::journald

  # Pass config options as a class parameter
  class { '::rsyslog::client':
    remote_servers => [
      {
        protocol => $protocol,
        host     => $host,
        port     => $port,
      },
      $remote_servers,
    ]
  }
}
