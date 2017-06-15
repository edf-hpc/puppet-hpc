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

# Activate cpu frequency scaling
# ## Hiera
# * `profiles::hardware::cpu_scaling::cpufreq_enable` Boolean to control if
#                                                     cpufreq method is
#                                                     used (default: false)
# * `profiles::hardware::cpu_scaling::pstate_enable` Boolean to control if
#                                                    pstate method is used
#                                                    (default: false)
#
# ## Relevant Autolookups
# * `pstate::script_file` Absolute path of the script launched by the service
# * `pstate::systemd_service_file` Absolute path of the systemd service unit
#                                  file`
# * `pstate::systemd_service_file_options Hash with the content of the systemd
#                                         service unit file`
# * `cpufreq::packages` Package to install
# * `cpufreq::packages_ensure` Boolean to control if module manage packages
# * `cpufreq::default_file` Absolute path of the default configuration file
# * `cpufreq::default_options` Hash with the content of the default 
#                              configuration file

class profiles::hardware::cpu_scaling {

  $cpufreq_enable = hiera('profiles::hardware::cpu_scaling::cpufreq_enable',
                          false)
  $pstate_enable = hiera('profiles::hardware::cpu_scaling::pstate_enable',
                         false)


  if $cpufreq_enable {
    include ::cpufreq
  }

  if $pstate_enable {
    include ::pstate
  }
}
