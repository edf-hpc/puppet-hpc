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

class slurmutils::jobsubmit::config inherits slurmutils::jobsubmit {

  if $::slurmutils::jobsubmit::config_manage {

      hpclib::print_config { $::slurmutils::jobsubmit::conf_file:
        style    => 'keyval',
        comments => '--',
        data     => $::slurmutils::jobsubmit::_conf_options,
      }

      exec { 'gen-qos-conf':
        command => $::slurmutils::jobsubmit::gen_qos_exec,
        creates => $::slurmutils::jobsubmit::gen_qos_conf,
      }

      hpclib::print_config { $::slurmutils::jobsubmit::wckeysctl_file:
        style     => 'keyval',
        separator => '=',
        data      => $::slurmutils::jobsubmit::_wckeysctl_options,
      }

      create_resources(hpclib::hpc_file,
                       $::slurmutils::jobsubmit::wckeys_data_files)

  }

}
