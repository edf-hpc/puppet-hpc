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

class mariadb::params {

  $config_manage     = true
  $service_enable    = true
  $service_ensure    = 'running'
  $service_name      = 'mariadb'
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
      $package_name         = ['mariadb-server']
      $service_manage       = true
      $galera_conf_file     = '/etc/mysql/mariadb.conf.d/galera.cnf'
      $disable_log_error    = true

      $galera_conf_options  = {
        mysqld => {
          'binlog_format'            => 'ROW',
          'default-storage-engine'   => 'innodb',
          'innodb_autoinc_lock_mode' => '2',
          'query_cache_size'         => '0',
          'query_cache_type'         => '0',
          'bind-address'             => '0.0.0.0',
          'wsrep_on'                 => 'ON',
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

  $disable_histfile      = true
  $prof_histfile_file    = '/etc/profile.d/100_disable_mariadb_histfile.sh'
  $prof_histfile_options = [ 'MYSQL_HISTFILE=/dev/null' ]
  $root_histfile_file    = '/root/.mysql_history'
  $root_histfile_target  = '/dev/null'

}
