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

class boothttp::config inherits boothttp {

  apache::vhost { "${::boothttp::servername}_bootsystem":
    ip            => $::boothttp::ip,
    servername    => $::boothttp::servername,
    port          => $::boothttp::port,
    docroot       => $::boothttp::config_dir_http,
    scriptalias   => "${::boothttp::config_dir_http}/cgi-bin",
    serveraliases => $::boothttp::serveraliases,
    docroot_mode  => '0750',
    docroot_group => 'www-data',
  }

  create_resources(boothttp::printconfig, hpc_atoh($::boothttp::supported_os))

  hpclib::print_config { $::boothttp::menu_config :
    style   => 'yaml',
    data    => $::boothttp::menu_config_options,
    mode    => 0644,
    require => File[$::boothttp::install::menu_file],
  }
}
