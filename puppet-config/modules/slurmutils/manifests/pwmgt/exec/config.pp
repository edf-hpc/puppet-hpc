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

class slurmutils::pwmgt::exec::config inherits slurmutils::pwmgt::exec {

  if $::slurmutils::pwmgt::exec::config_manage {

    hpclib::print_config { $::slurmutils::pwmgt::exec::config_file:
      style => 'ini',
      data  => $::slurmutils::pwmgt::exec::_config_options,
    }

    ssh_authorized_key { 'pwmgt_server':
      user    => 'root',
      type    => $::slurmutils::pwmgt::exec::pub_key_type,
      key     => $::slurmutils::pwmgt::exec::pub_key,
      options => 'command="/usr/lib/slurm-pwmgt/exec/slurm-stop-wrapper"',
    }

  }

}
