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

  if $::mariadb::config_manage {

    hpclib::print_config { $::mariadb::galera_conf_file :
      data  => $::mariadb::_galera_conf_options,
      style => 'ini',
    }

    if $::mariadb::log_to_rsyslog {

      rsyslog::imfile { 'mariadb-error':
        file_name     => $::mariadb::log_error_file,
        file_tag      => 'mariadb-error:',
        file_facility => 'error',
      }
      rsyslog::imfile { 'mariadb-info':
        file_name     => $::mariadb::log_info_file,
        file_tag      => 'mariadb-info:',
        file_facility => 'info',
      }
      rsyslog::imfile { 'mariadb-slow':
        file_name     => $::mariadb::log_slow_file,
        file_tag      => 'mariadb-slow:',
        file_facility => 'info',
      }
      rsyslog::imfile { 'mariadb-slow-legacy':
        file_name     => $::mariadb::log_slow_legacy_file,
        file_tag      => 'mariadb-slow:',
        file_facility => 'info',
      }

    }

    if $::mariadb::enable_ssl {

      hpclib::hpc_file { $::mariadb::ssl_cert_file :
        source => $::mariadb::ssl_cert_src,
        mode   => '0644',
        owner  => 'mysql',
        group  => 'mysql',
      }

      file { $::mariadb::ssl_key_file :
        content => decrypt($::mariadb::ssl_key_src,
                           $::mariadb::decrypt_passwd),
        mode    => '0400',
        owner   => 'mysql',
        group   => 'mysql',
      }


    }

  }
}
