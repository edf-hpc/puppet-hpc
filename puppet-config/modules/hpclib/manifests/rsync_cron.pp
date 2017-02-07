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

# Sync a remote directory periodically
#
# @param target_dir Absolute path of the local directory
# @param source_host Name of the remote source host
# @param source_dir Absolute path of source on the remote host
# @param delete boolean: if true files on the source not on target are deleted (default: true)
define hpclib::rsync_cron(
  $target_dir,
  $source_host,
  $source_dir,
  $delete = true,
) {

  validate_absolute_path($target_dir)
  validate_string($source_host)
  validate_absolute_path($source_dir)
  validate_bool($delete)

  $basedir = dirname($target_dir)
  ensure_resource(file, $basedir, {'ensure' => 'directory'})

  if $delete {
    $delete_option = '--delete'
  } else {
    $delete_option = ''
  }

  cron { "hpclib_rsync_cron_${name}":
    command => "/usr/bin/rsync ${delete_option} -ah '${source_host}:${source_dir}' '${target_dir}' ",
    user    => 'root',
    hour    => '3',
    minute  => '0',
  }

}
