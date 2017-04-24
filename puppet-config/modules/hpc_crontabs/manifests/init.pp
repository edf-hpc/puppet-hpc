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

# Replace the standard directory for crontabs with a symbolic link to another
# directory (that is backuped, for example)
#
# @param crontabs_dir_source Path to the original crontabs directory on the
#                            system (default: '/var/spool/cron/crontabs')
# @param crontabs_dir_destination Path to the target crontabs directory
#
class hpc_crontabs (
  $crontabs_dir_source      = $hpc_crontabs::params::crontabs_dir_source,
  $crontabs_dir_destination = '',
) inherits hpc_crontabs::params {

  validate_absolute_path($crontabs_dir_source)
  validate_absolute_path($crontabs_dir_destination)

  anchor { 'hpc_crontabs::begin': } ->
  class { '::hpc_crontabs::config': } ->
  anchor { 'hpc_crontabs::end': }

}
