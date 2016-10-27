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

# Hide processes from other users by remounting /proc with hipepid option
#
# @param hidepid Value of the hidepid option (0, 1 or 2)
# @param gid     A group allowed to gather information on all processes 
define hidepid::mount (
  $hidepid = '2',
  $gid     = '',
) {
  # Define the proper options 
  if $gid == '' {
    $options = "defaults,hidepid=${hidepid}"
  } else {
    $options = "defaults,hidepid=${hidepid},gid=${gid}"
  }

  # Remount /proc with the proper options
  mount { '/proc':
    ensure   => 'mounted',
    device   => 'proc',
    fstype   => 'proc',
    options  => $options,
    atboot   => true,
    remounts => true,
    pass     => 0,
    dump     => 0,
  }
}

