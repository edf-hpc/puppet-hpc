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

class kerberos::config inherits kerberos {

  file { $config_dir :
    ensure => directory,
  }

  hpclib::print_config { "${config_dir}/${config_file}" :
    style   => 'ini',
    data    => $config_options,
    mode    => 0600,
    require => [Package[$packages],File[$config_dir]],
  }

  file { "${config_dir}/${keytab_file}" :
    ensure  => present,
    content => decrypt("${directory_source}/${hostname}.${keytab_file}.enc", $decrypt_passwd),
    mode    => '0600',
    require => [Package[$packages],File[$config_dir]],
  }

}
