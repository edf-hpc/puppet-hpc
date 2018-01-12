##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016 EDF S.A.                                           #
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

define icinga2::ident ($src) {

 if ! defined(Class['icinga2::admin']) {

  $_ident_dir_opts = {
    ensure => 'directory',
    mode   => '0755',
    owner  => $::icinga2::user,
    group  => $::icinga2::user,
  }

  ensure_resource('file', $::icinga2::ident_dir, $_ident_dir_opts)

  $_ident_file = "${::icinga2::ident_dir}/${name}"

  file { $_ident_file :
    ensure  => 'present',
    owner   => $::icinga2::user,
    group   => $::icinga2::user,
    mode    => '0400',
    content => decrypt($src, $::icinga2::decrypt_passwd),
  }

 }

}
