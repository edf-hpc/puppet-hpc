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

class mariadb::params {

  $config_manage     = true
  $service_enable    = true
  $service_ensure    = 'running'
  $nodes             = [ 'localhost' ]

  ### Package ###
  $package_ensure    = 'present'
  case $::osfamily {
    'RedHat': {
      ### TODO ###
      $package_manage       = false
      $service_manage       = false
    }
    'Debian': {
      $package_manage       = true
      $package_name         = ['mariadb-galera-server']
      $mariadb_preseed_file = '/var/local/mysql-server.preseed'
      $mariadb_preseed_tmpl = 'mariadb/mysql-server.preseed.erb'
      $service_manage       = true
      $conf_dir_path        = '/etc/mysql'
      $galera_dir_path      = "${conf_dir_path}/conf.d"
      $main_conf_file       = "${conf_dir_path}/debian.cnf"
      $service_name         = 'mysql'
      $galera_conf_file     = "${galera_dir_path}/galera.cnf"
      $galera_conf_tmpl     = 'db/galera.erb'
      $disable_log_error    = true
      $mysql_conf_options   = {
        'client'              => {
          'host'                => 'localhost',
          'user'                => 'debian-sys-maint',
          'password'            => '',
          'socket'              => '/var/run/mysqld/mysqld.sock',
        },

        'mysql_upgrade'       => {
          'host'                => 'localhost',
          'user'                => 'debian-sys-maint',
          'password'            => '',
          'socket'              => '/var/run/mysqld/mysqld.sock',
          'basedir'             => '/usr',
        },
      }

      $galera_conf_options  = {
        mysqld => {
          'binlog_format'            => 'ROW',
          'default-storage-engine'   => 'innodb',
          'innodb_autoinc_lock_mode' => '2',
          'query_cache_size'         => '0',
          'query_cache_type'         => '0',
          'bind-address'             => '0.0.0.0',
          'wsrep_provider'           => '/usr/lib/galera/libgalera_smm.so',
          'wsrep_cluster_name'       => '"galera_cluster"',
          'wsrep_sst_method'         => 'rsync',
        }
      }
    }
    default: {
      $package_manage       = false
      $service_manage       = false
    }
  }
}

