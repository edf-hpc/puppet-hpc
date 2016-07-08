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

# Setup a database server (MariaDB/Galera)
#
# The MariaDB/Galera cluster should be configured in your hiera to have a
# working configuration:
#
# ```
# ###### Slurm DBD database ####
# galera_base_name:             "%{hiera('cluster_prefix')}%{::my_db_server}"
# mariadb::galera_conf_options:
#   mysqld:
#    binlog_format:            'ROW'
#    default-storage-engine:   'innodb'
#    innodb_autoinc_lock_mode: '2'
#    query_cache_size:         '0'
#    query_cache_type:         '0'
#    bind-address:             '0.0.0.0'
#    wsrep_provider:           '/usr/lib/galera/libgalera_smm.so'
#    wsrep_cluster_name:       '"galera_cluster"'
#    wsrep_cluster_address:    "\"gcomm://%{hiera('galera_base_name')}1,%{hiera('galera_base_name')}2\""
#    wsrep_sst_method:         'rsync'
# mariadb::mysql_root_pwd:      'GALERA_ROOT_PASSWORD_OVERRIDEME_IN_EYAML'
# ```
class profiles::db::server {
  include ::mariadb
}
