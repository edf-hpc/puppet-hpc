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

class conman (
  $pkgs        = $::conman::params::pkgs,
  $pkgs_ensure = $::conman::params::pkgs_ensure,
  $serv        = $::conman::params::serv,
  $serv_ensure = $::conman::params::serv_ensure,
  $serv_enable = $::conman::params::serv_enable,
  $logrotate   = $::conman::params::logrotate,
  $server_opts = {},
  $global_opts = {},
) inherits conman::params {
  validate_array($pkgs)
  validate_bool($pkgs_ensure)
  validate_string($serv)
  validate_string($serv_ensure)
  validate_bool($serv_enable)
  validate_bool($logrotate)

  validate_hash($server_opts)
  if $server_opts['logdir'] {
    validate_absolute_path($server_opts['logdir'])
  }
  if $server_opts['pidfile'] {
    validate_absolute_path($server_opts['pidfile'])
  }
  $_server_opts = merge($server_opts, $::conman::params::server_opts_defaults)

  validate_hash($global_opts)
  $_global_opts = merge($global_opts, $::conman::params::global_opts_defaults)

  anchor { 'conman::begin': } ->
  class { '::conman::install': } ->
  class { '::conman::config': } ->
  class { '::conman::service': } ->
  anchor { 'conman::end': }

}
