##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016-2017 EDF S.A.                                      #
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

class nscang::server::config inherits nscang::server {

  if $::nscang::server::config_manage {

    if $::nscang::server::services_manage {
      $_services = Service[$::nscang::server::services]
    } else {
      $_services = []
    }

    if $::nscang::server::listen_address != '0.0.0.0' or $::nscang::server::listen_port != $::nscang::server::params::listen_port {
      # NSCA-ng uses socket activation, the socket is defined in a systemd unit
      # this create an override file if necessary
      if $::nscang::server::listen_address != '0.0.0.0' {
        $stream = "ListenStream=${::nscang::server::listen_address}:${$::nscang::server::listen_port}"

      } else {
        $stream = "ListenStream=${::nscang::server::listen_port}"

      }

      $content = [
        '[Socket]',
        'FreeBind=true',
        'ListenStream=',
        $stream
      ]

      systemd::unit_override{ 'nscang_socket_listen':
        unit_name   => 'nsca-ng-server.socket',
        style       => 'linebyline',
        content     => $content,
        restart_now => true,
      }
    }


    file { $::nscang::server::config_file:
      content => template('nscang/server.erb'),
      owner   => $::nscang::server::user,
      group   => $::nscang::server::user,
      mode    => '0600',
      notify  => $_services,
    }

  }
}
