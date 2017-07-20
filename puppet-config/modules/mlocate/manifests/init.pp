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

# Install and setup mlocate on nodes
#
# @param packages         Packages list (default: 'mlocate')
# @param packages_ensure  Packages install mode
# @param config_file      Configuration file (default: '/etc/updatedb.conf')
# @param prunefs Array of default FS types that should be ignored
# @param extra_prunefs Array of extra FS types that should be ignored
# @param prunepaths Array of default paths that should be ignored
# @param extra_prunepaths Array of extra paths that should be ignored
# @parma prune_bind_mounts Ignore directories below a bind mount (default: yes)

class mlocate (
  $packages          = $::mlocate::params::packages,
  $packages_ensure   = $::mlocate::params::packages_ensure,
  $config_file       = $::mlocate::params::config_file,
  $prunefs           = $::mlocate::params::prunefs,
  $extra_prunefs     = $::mlocate::params::extra_prunefs,
  $prunepaths        = $::mlocate::params::prunepaths,
  $extra_prunepaths  = $::mlocate::params::extra_prunepaths,
  $prune_bind_mounts = $::mlocate::params::prune_bind_mounts,
) inherits mlocate::params {
  validate_absolute_path($config_file)
  validate_array($prunefs)
  validate_array($extra_prunefs)
  validate_array($prunepaths)
  validate_array($extra_prunepaths)
  validate_bool($prune_bind_mounts)

  anchor { 'mlocate::begin': } ->
  class { '::mlocate::install': } ->
  class { '::mlocate::config': } ->
  anchor { 'mlocate::end': }

}
