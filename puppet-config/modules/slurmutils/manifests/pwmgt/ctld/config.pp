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

class slurmutils::pwmgt::ctld::config inherits slurmutils::pwmgt::ctld {

  if $::slurmutils::pwmgt::ctld::config_manage {

    hpclib::print_config { $::slurmutils::pwmgt::ctld::config_file:
      style => 'ini',
      data  => $::slurmutils::pwmgt::ctld::_config_options,
      owner   => 'slurm',
      mode  => '0600',
    }

    if $::slurmutils::pwmgt::ctld::priv_key_manage {
      file { $::slurmutils::pwmgt::ctld::priv_key_file:
        content => decrypt($::slurmutils::pwmgt::ctld::priv_key_enc, $::slurmutils::pwmgt::ctld::decrypt_passwd),
        owner   => 'slurm',
        group   => 'slurm',
        mode    => '0600',
      }
    }
  }

}
