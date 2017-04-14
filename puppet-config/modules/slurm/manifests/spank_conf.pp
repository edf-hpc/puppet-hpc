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

# Manage spank plugin configuration file
#
# @param name Name of the spank plugin (ex: 'private-tmp')
# @param conf Name of the configuration file in slurm plugstack directory (ex:
#             'private-tmp')
# @param opts Configuration parameters of the spank plugin
define slurm::spank_conf (
  $conf = undef,
  $opts = undef,
) {

  if $conf == undef or $opts == undef {
    debug("skip managing spank plugin ${name} configuration as it is not fully defined")
  } else {

    validate_string($conf)
    validate_hash($opts)
    validate_bool($opts['required'])
    validate_absolute_path($opts['plugin'])
    validate_array($opts['args'])

    file { "${::slurm::spank_conf_dir}/${conf}.conf":
      content => template('slurm/spank_conf.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

  }

}
