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

class slurmcommons (
  $bin_dir_path          = $slurmcommons::params::bin_dir_path,
  $conf_dir_path         = $slurmcommons::params::conf_dir_path,
  $logs_dir_path         = $slurmcommons::params::logs_dir_path,
  $script_dir_path       = $slurmcommons::params::script_dir_path,
  $main_conf_file        = $slurmcommons::params::main_conf_file,
  $part_conf_file        = $slurmcommons::params::part_conf_file,
  $slurm_conf_options    = $slurmcommons::params::slurm_conf_options,
  $partitions_conf       = $slurmcommons::params::partitions_conf,
) inherits slurmcommons::params {

  ### Validate params ###
  validate_absolute_path($bin_dir_path)
  validate_absolute_path($conf_dir_path)
  validate_absolute_path($logs_dir_path)
  validate_absolute_path($script_dir_path)
  validate_absolute_path($main_conf_file)
  validate_absolute_path($part_conf_file)
  validate_hash($slurm_conf_options)
  validate_array($partitions_conf)
  class { '::slurmcommons::config': }
}
