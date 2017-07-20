##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2017 EDF S.A.                                           #
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

class mlocate::config inherits mlocate {

  $all_prunefs = join(concat($::mlocate::prunefs, $::mlocate::extra_prunefs), ' ')
  $all_prunepaths = join(concat($::mlocate::prunepaths, $::mlocate::extra_prunepaths), ' ')

  if $::mlocate::prune_bind_mounts {
    $prune_bind_mounts_str = 'yes'
  } else {
    $prune_bind_mounts_str = 'no'
  }

  $options = {
    'PRUNE_BIND_MOUNTS' => "\"${prune_bind_mounts_str}\"",
    'PRUNEFS'           => "\"${all_prunefs}\"",
    'PRUNEPATHS'        => "\"${all_prunepaths}\"",
  }

  hpclib::print_config{ $::mlocate::config_file:
    style => 'keyval',
    data  => $options,
  }

}

