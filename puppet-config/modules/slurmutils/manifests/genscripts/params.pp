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

class slurmutils::genscripts::params {

  $install_manage  = true
  $packages_manage = true
  $packages        = ['slurm-llnl-generic-scripts-plugin']
  $packages_ensure = 'latest'

  # Those are slurm configuration parameters required to use generic scripts.
  # The slurm configuration file is managed by slurm module so this module
  # cannot inject these configuration parameters into slurm configuration by
  # itself. They are defined here at the disposal of the profile which can
  # extract them to then inject them into the slurm configuration options hash
  # for slurm public class.
  $scripts_dir     = "/usr/lib/slurm/generic-scripts"
  $genscripts_options = {
    'Prolog'          => "${scripts_dir}/Prolog.sh",
    'PrologSlurmctld' => "${scripts_dir}/PrologSlurmctld.sh",
    'TaskProlog'      => "${scripts_dir}/TaskProlog.sh",
    'SrunProlog'      => "${scripts_dir}/SrunProlog.sh",
    'Epilog'          => "${scripts_dir}/Epilog.sh",
    'EpilogSlurmctld' => "${scripts_dir}/EpilogSlurmctld.sh",
    'TaskEpilog'      => "${scripts_dir}/TaskEpilog.sh",
    'SrunEpilog'      => "${scripts_dir}/SrunEpilog.sh",
  }


}
