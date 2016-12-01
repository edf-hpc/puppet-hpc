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

# Create a file with an hpc_source_file content
#
# @param backup Save the file before it is replaced.
# @param mode   Permissions mode of the file.
# @param owner  User owner of the file.
# @param group  Group owner of the file.
# @param target Path of the file to write.
# @param source Source(s) of the file (absolute path or URL), can be a
#               a single value or an array of values
define hpclib::hpc_file(
  $source,
  $target = $title,
  $mode   = '0644',
  $owner  = 'root',
  $group  = 'root',
  $backup = undef,
) {

  validate_string($mode)
  validate_string($owner)
  validate_string($group)
  if $backup {
    validate_bool($backup)
  }
  validate_absolute_path($target)

  file { $target:
    content => hpc_source_file($source),
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    backup  => $backup,
  }

}

