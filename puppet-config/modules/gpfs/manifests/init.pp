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

# Deploys the GPFS components. 
#
# @param install_manage  Public class manages the installation (default: true)
# @param packages        Packages to install (default: OS dependant)
# @param packages_manage Public class installs the packages (default: true)
# @param packages_ensure Target state for the packages (default: 'present')
# @param config_manage   Public class manages the configuration (default: true)
# @param file_mode	 Permissions for files (Default: '640')
# @param config_file     Absolute path of the configuration file for
#                        GPFS (Default: '/var/mmfs/gen/mmsdrfs')
# @param config_src      Path of the encrypted source of the configuration
#                        file (Default: 'gpfs/mmsdrfs.enc')
# @param key_file        Absolute path of the SSL key file used by GPFS for
#                        inter-clusters communications
#                        (Default:'/var/mmfs/ssl/stage/genkeyData1')
# @param key_src         Path of the encrypted source of the SSL key file
#                        (Default: 'gpfs/genkeyData1.enc')
# @param cluster         Name of the current cluster (Default: 'cluster')
# @param service_manage  Public class manages the service state (default: true)
# @param service_name    Name of the service (Default: 'gpfs')
# @param service_ensure  Target state for the service (default: 'running')
# @param service_enable  The service starts at boot time (default: true)
# @param public_key      Public authorized key for SSH communications to
#                        add for the root user
# @param decrypt_passwd  Password to decrypt encrypted files
class gpfs (
  $install_manage  = $::gpfs::params::install_manage,
  $packages        = $::gpfs::params::packages,
  $packages_manage = $::gpfs::params::packages_manage,
  $packages_ensure = $::gpfs::params::packages_ensure,
  $config_manage   = $::gpfs::params::service_manage,
  $file_mode       = $::gpfs::params::file_mode,
  $config_file     = $::gpfs::params::config_file,
  $config_src      = $::gpfs::params::config_src,
  $key_file        = $::gpfs::params::key_file,
  $key_src         = $::gpfs::params::key_src,
  $cluster         = $::gpfs::params::cluster,
  $service_manage  = $::gpfs::params::service_manage,
  $service_name    = $::gpfs::params::service_name,
  $service_ensure  = $::gpfs::params::service_ensure,
  $service_enable  = $::gpfs::params::service_enable,
  $public_key,
  $decrypt_passwd,
) inherits gpfs::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($service_manage)
  validate_bool($config_manage)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $config_manage {
    validate_string($file_mode)
    validate_string($decrypt_passwd)
    validate_absolute_path($config_file)
    validate_string($config_src)
    validate_absolute_path($key_file)
    validate_string($key_src)
    validate_string($cluster)
    validate_string($public_key)
  }

  if $service_manage {
    validate_string($service_name)
    validate_string($service_ensure)
    validate_bool($service_enable)
  }

  anchor { 'gpfs::begin': } ->
  class { '::gpfs::install': } ->
  class { '::gpfs::config': } ->
  class { '::gpfs::service': } ->
  anchor { 'gpfs::end': }

}
