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

# Log collection on clients
#
# ## Hiera
# * `profiles::log::client::remote_type`
# * `profiles::log::client::log_local`
# * `profiles::log::client::server`
# * `profiles::log::client::port`
class profiles::log::client {

  ## Hiera lookups

  $remote_type = hiera('profiles::log::client::remote_type')
  $log_local   = hiera('profiles::log::client::log_local')
  $server      = hiera('profiles::log::client::server')
  $port        = hiera('profiles::log::client::port')

  # Pass config options as a class parameter
  class { '::rsyslog::client':
  remote_type               => $remote_type,
  log_local                 => $log_local,
  server                    => $server,
  port                      => $port,
  }
}
