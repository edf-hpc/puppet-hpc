##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2014-2018 EDF S.A.                                      #
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

class opa::config inherits opa {

  ::hpclib::print_config { $::opa::irqbalance_config:
    style           => 'keyval',
    data            => $::opa::irqbalance_options,
    upper_case_keys => true,
    notify          => Service[$::opa::irqbalance_service],
  }

  if $::opa::modprobe_hfi1_file {
    ::hpclib::print_config { $::opa::modprobe_hfi1_file:
      style  => 'linebyline',
      data   => $::opa::modprobe_hfi1_options,
      notify => Service[$::opa::service_name],
    }
  }

  if $::opa::modprobe_ib_ipoib_file {
    ::hpclib::print_config { $::opa::modprobe_ib_ipoib_file:
      style  => 'linebyline',
      data   => $::opa::modprobe_ib_ipoib_options,
      before => Systemd::Modules_load['opa'],
      notify => [
        Service[$::opa::service_name],
        Systemd::Modules_load['opa'],
      ]
    }
  }

  ::systemd::modules_load { 'opa':
    data => $::opa::kernel_modules
  }
}
