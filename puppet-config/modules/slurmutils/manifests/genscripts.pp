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

# Deploys the Slurm generic scripts utility
#
# @param install_manage  Let this class manage the installation (default: true)
# @param packages_manage Let this class installs the packages (default: true)
# @param packages        Array of packages names (default:
#                        [''slurm-llnl-generic-scripts-plugin'])
# @param packages_ensure State of the packages (default: `latest`)
class slurmutils::genscripts (
  $install_manage    = $::slurmutils::genscripts::params::install_manage,
  $packages_manage   = $::slurmutils::genscripts::params::packages_manage,
  $packages          = $::slurmutils::genscripts::params::packages,
  $packages_ensure   = $::slurmutils::genscripts::params::packages_ensure,
  $config_manage     = $::slurmutils::genscripts::params::config_manage,
  $conf_file         = $::slurmutils::genscripts::params::conf_file,
  $conf_options      = {},
  $exec_file         = $::slurmutils::genscripts::params::exec_file,
) inherits slurmutils::genscripts::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  anchor { 'slurmutils::genscripts::begin': } ->
  class { '::slurmutils::genscripts::install': } ->
  anchor { 'slurmutils::genscripts::end': }
}
