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

    if size($::nscang::server::listen_addresses) > 0 or $::nscang::server::listen_port != $::nscang::server::params::listen_port {
      # NSCA-ng uses socket activation, the socket is defined in a systemd unit
      # this create an override file if necessary
      if size($::nscang::server::listen_addresses) > 0 {
        $suffixed_addrs = suffix($::nscang::server::_listen_addresses, ":${$::nscang::server::listen_port}")
        $streams = prefix($suffixed_addrs, 'ListenStream=')

      } else {
        $streams = ["ListenStream=${::nscang::server::listen_port}"]

      }

      $content_header = [
        '[Socket]',
        'FreeBind=true',
        'ListenStream=',
      ]

      $content = concat($content_header, $streams)

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
