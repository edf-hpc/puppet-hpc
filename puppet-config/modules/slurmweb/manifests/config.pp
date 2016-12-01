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

class slurmweb::config inherits slurmweb {

  hpclib::print_config { $::slurmweb::config_file :
    style    => 'ini',
    comments => '#',
    data     => $::slurmweb::config_options,
  }

  hpclib::hpc_file { $slurmweb::racks_file :
    source => $slurmweb::racks_file_source,
    mode   => '0644',
  }

  file { $slurmweb::secret_file :
    content => decrypt($slurmweb::secret_file_source,$slurmweb::decrypt_passwd),
    mode    => '0400',
    owner   => $::slurmweb::slurm_user,
  }

  hpclib::hpc_file { $slurmweb::ssl_cert_file :
    source => $slurmweb::ssl_cert_source,
    mode   => '0644',
    owner  => 'www-data',
    group  => 'www-data',
    notify => Apache::Vhost[$::hostname],
  }

  file { $slurmweb::ssl_key_file :
    content => decrypt($slurmweb::ssl_key_source,$slurmweb::decrypt_passwd),
    mode    => '0400',
    owner   => 'www-data',
    group   => 'www-data',
    notify  => Apache::Vhost[$::hostname],
  }

  apache::vhost { $::hostname :
    default_vhost          => true,
    port                   => '443',
    docroot                => '/var/www/html',
    ssl                    => true,
    ssl_protocol           => 'all -SSLv3',
    ssl_cipher             => 'HIGH:!aNULL',
    ssl_key                => $::slurmweb::ssl_key_file,
    ssl_cert               => $::slurmweb::ssl_cert_file,
    wsgi_daemon_process    => "slurm-web-restapi user=${::slurmweb::slurm_user} group=www-data threads=5 home=/tmp",
    wsgi_script_aliases    => { '/slurm-restapi' => '/usr/share/slurm-web/restapi/slurm-web-restapi.wsgi' },
    wsgi_application_group => '%{GLOBAL}',
    wsgi_process_group     => 'slurm-web-restapi',
    directories            => [
      { path        => '/usr/share/slurm-web/restapi',
        ssl_options => ['+StdEnvVars'],
        'Require'   => 'all granted',
      },
    ],
  }
}
