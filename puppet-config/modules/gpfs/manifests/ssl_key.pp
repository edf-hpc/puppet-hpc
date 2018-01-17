##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2018 EDF S.A.                                      #
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

define gpfs::ssl_key (
  $src,
  $file = undef,
) {

  if $file == undef {
    $_file = "${::gpfs::params::ssl_key_dir}/${name}"
  } else {
    $_file = $file
  }

  file { $_file:
    content => decrypt($src, $::gpfs::decrypt_passwd),
    owner   => 'root',
    group   => 'root',
    mode    => '0400',
    notify  => Class['::gpfs::service']
  }
}
