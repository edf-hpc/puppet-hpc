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

class openldap::config inherits openldap {

  $service_dir = "/etc/systemd/system/${::openldap::service}.service.d"
  $service_override_file = "${service_dir}/override.conf"

  file { $service_dir:
    ensure => directory,
  }

  hpclib::print_config { $service_override_file:
    style  => 'ini',
    data   => $::openldap::_service_override,
    notify => Exec['openldap_systemctl_daemon_reload'],
  }

  exec { 'openldap_systemctl_daemon_reload':
    refreshonly => true,
    command     => '/bin/systemctl daemon-reload',
    notify      => Class['::openldap::service'],
  }

  hpclib::print_config { $::openldap::default_file :
    style   => 'keyval',
    data    => $::openldap::default_options,
    require => Package[$::openldap::packages],
    notify  => Service[$::openldap::service],
  }

}
