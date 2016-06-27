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

class mariadb::config {

  if $mariadb::config_manage {

    $tmp_mysql_conf_options   = {
      'client' => {
        'password' => $mariadb::mysql_root_pwd,
      },
      'mysql_upgrade' => {
        'password' => $mariadb::mysql_root_pwd,
      },
    }

    ### Merge first section ###
    $client  = merge($mariadb::mysql_conf_options['client'], $tmp_mysql_conf_options['client'])
    $upgrade = merge($mariadb::mysql_conf_options['mysql_upgrade'], $tmp_mysql_conf_options['mysql_upgrade'])
    $local_mysql_conf_options   = {
      'client'        => $client,
      'mysql_upgrade' => $upgrade,
    }

    file { $mariadb::conf_dir_path :
      ensure  => 'directory',
    }

    file { $mariadb::galera_dir_path :
      ensure  => 'directory',
      require => File[$mariadb::conf_dir_path],
    }

    hpclib::print_config { $mariadb::galera_conf_file :
      data  => $mariadb::galera_conf_options,
      style => 'ini',
    }

    hpclib::print_config { $mariadb::main_conf_file :
      style   => 'ini',
      data    => $local_mysql_conf_options,
      mode    => '0600',
      backup  => false,
      require => File[$mariadb::conf_dir_path],
    }
  }
}
