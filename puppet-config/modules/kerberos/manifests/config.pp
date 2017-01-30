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

class kerberos::config inherits kerberos {

  hpclib::print_config { $::kerberos::config_file:
    style => 'ini',
    data  => $::kerberos::config_options,
    mode  => 0644,
  }

  file { $::kerberos::keytab_file:
    ensure  => present,
    content => decrypt("${::kerberos::keytab_source_dir}/${::hostname}.krb5.keytab.enc", $::kerberos::decrypt_passwd),
    mode    => '0600',
  }

}
