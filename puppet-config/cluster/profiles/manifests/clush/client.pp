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

class profiles::clush::client {

  $roles_groups = hpc_roles_nodeset()
  if $roles_groups == {} {
    fail("Roles to nodeset hash is empty, this should never happen, the local node should have a role.")
  }
  $rooted_roles_groups = { 
    "hpc_roles" => $roles_groups
  }

  $hiera_groups = hiera_hash('profiles::clustershell::groups', {})
  if $hiera_groups != {} {
    $rooted_hiera_groups = { 
      "hpc" => $hiera_groups
    }
    $default_source = 'hpc'
  } else {
    # No group defined in hiera, default to the role groups
    $rooted_hiera_groups = {}
    $default_source = 'hpc_roles'
  }

  $groups = merge($rooted_roles_groups, $rooted_hiera_groups)

  class { '::clustershell':
    groups => $groups,
    groups_options => {
      'Main' => {
        'default' => $default_source,
      },
    }
  }
}
