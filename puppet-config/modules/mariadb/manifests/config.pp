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

    # This is required in scibian packages to make sure mysqld_safe script will
    # redirect all logs to syslog and launch mysqld asynchronously with wait
    # bash internal command. This way, mysqld_safe script can properly trap
    # SIGTERM signal sent by systemd on service stop.
    if $mariadb::disable_log_error {
      # make sure the log_error parameter is commented-out
      file_line { 'disable-mysql-log-error':
        ensure => present,
        path   => '/etc/mysql/my.cnf',
        line   => "#log_error = /var/log/mysql/error.log",
        match  => "^.*log_error",
      }
    }

    hpclib::print_config { $mariadb::galera_conf_file :
      data  => $mariadb::_galera_conf_options,
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
