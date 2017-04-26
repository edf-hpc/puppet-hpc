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

class glpicollector::config inherits glpicollector {

  apache::vhost { "${::glpicollector::servername}_glpicollector":
    servername    => $::glpicollector::servername,
    port          => $::glpicollector::port,
    docroot       => $::glpicollector::config_dir_http,
    serveraliases => $::glpicollector::serveraliases,
    docroot_mode  => '0750',
    docroot_group => 'www-data',
  }

  create_resources(hpclib::hpc_file, $::glpicollector::hpc_files)

  cron { 'glpi_push' :
    command    => '/usr/local/sbin/glpi_push 1> /var/log/fusioninventory.log 2>&1',
    user       => 'root',
    hour       => 12,
    minute     => 0,
    monthday   => 1
  }
}
