##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2015 EDF S.A.                                      #
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

define tools::decryptor($file = $title, $source = '', $mode = '600') {

  if $source == '' {
    $target = "${file}.enc"
  } else {
    $target = $source
  }

  $script = "${prerequisites::params::libpath}/../utils/decrypt_file.rb"

  exec { $target :
    command => "${script} ${target} ${file} ${mode}",
    require => File[$target],
  }

}
