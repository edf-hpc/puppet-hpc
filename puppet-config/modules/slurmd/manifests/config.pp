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

class slurmd::config {

  if $slurmd::config_manage {

    require slurmcommons

    if $slurmd::enable_cgroup {
      hpclib::print_config { $slurmd::cgroup_conf_file:
        style  => 'keyval',
        data   => $::slurmd::_cgroup_options,
        notify => Class['::slurmd::service'],
      }

      ensure_resource('file', $slurmd::cgroup_rel_path, {'ensure' => 'directory' })

      file { $slurmd::cgroup_relscript_file:
        mode    => '0744', # must be executable only by root
        owner   => 'root',
        source  => $slurmd::cgroup_relscript_src,
        require => File[$slurmd::cgroup_rel_path],
      }

      $cgroup_links = {
        "${slurmd::cgroup_rscpuset_file}" => { },
        "${slurmd::cgroup_rs_freez_file}" => { },
        "${slurmd::cgroup_rs_mem_file}" => { },
      }

      $cgroup_ln_default = {
        ensure  => link,
        target  => $slurmd::cgroup_relscript_file,
        require => File[$slurmd::cgroup_relscript_file],
      }
      create_resources(file,$cgroup_links,$cgroup_ln_default)
    }
  }
    rsyslog::imfile { 'slurmd':
      file_name     => '/var/log/slurm-llnl/slurmd.log',
      file_tag      => 'slurmd:',
      file_facility => 'info',
    }
}
