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

class slurmutils::pwmgt::ctld::params {

  $install_manage  = true
  $packages_manage = true
  $packages        = ['slurm-pwmgt-nodes']
  $packages_ensure = 'latest'

  $config_manage   = true
  $config_file     = '/etc/slurm-llnl/pwmgt/main.conf'

  $config_options_defaults = {
    'ipmi' => {
      prefix   => 'bmc',
      user     => 'admin',
      password => 'admin',
    },
  }

  # Those are slurm configuration parameters required to use generic scripts.
  # The slurm configuration file is managed by slurm module so this module
  # cannot inject these configuration parameters into slurm configuration by
  # itself. They are defined here at the disposal of the profile which can
  # extract them to then inject them into the slurm configuration options hash
  # for slurm public class.
  $libexec_dir     = '/usr/lib/slurm-pwmgt/exec'
  $pwmgt_options = {
    'SuspendProgram' => "${libexec_dir}/slurm-stop-nodes",
    'ResumeProgram'  => "${libexec_dir}/slurm-start-nodes",
    'ResumeTimeout'  => '800',
    'SuspendTime'    => '900',
  }

  $priv_key_manage = true
  $priv_key_file = '/etc/slurm-llnl/pwmgt/id_rsa_slurm'
}
