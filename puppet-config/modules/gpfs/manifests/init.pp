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
# @param lum_files       Optional hash of LUM files to install (default: {})
# @param lum_hpc_files   Optional hash of LUM files to install with
#                        hpclib::hpc_file (default: {})
# @param config_manage   Public class manages the configuration (default: true)
# @param file_mode       Permissions for files (Default: '0644')
# @param config_file     Absolute path of the configuration file for
#                        GPFS (Default: '/var/mmfs/gen/mmsdrfs')
# @param config_src      Path of the encrypted source of the configuration
#                        file (Default: 'gpfs/mmsdrfs.enc')
# @param ssh_private_key_src
#                        URL to private SSH file for inter-cluster
#                        communications (default: undef)
# @param ssh_hosts       Hosts associated to SSH private key in configuration
#                        (default: '*')
# @param ssl_keys        Hash of SSL keys definitions used by GPFS for
#                        inter-clusters communications (default: {})
# @param cluster         Name of the current cluster (Default: 'cluster')
# @param service_manage  Public class manages the service state (default: true)
# @param service_name    Name of the service (Default: 'gpfs')
# @param service_ensure  Target state for the service (default: 'running')
# @param service_enable  The service starts at boot time (default: true)
# @param ccr_enable      Ccr mode is enabled on Gpfs cluster(s)
# @param ccr_nodes_file  Absolute path for the ccr.nodes file in ccr mode
#                        (default: '/var/mmfs/ccr/ccr.nodes')
# @param ccr_noauth_source
#                        (default: '/var/mmfs/ccr/ccr.noauth')
# @param ccr_nodes_source
#                        (default: '/var/mmfs/ccr/ccr.nodes')
# @param ccr_noauth_file Absolute path for the ccr.noauth file in ccr mode
#                        (default: '/var/mmfs/ccr/ccr.noauth')
# @param ssh_public_key  Public authorized key for SSH communications to
#                        add for the root user
# @param decrypt_passwd  Password to decrypt encrypted files
class gpfs (
  $install_manage      = $::gpfs::params::install_manage,
  $packages            = $::gpfs::params::packages,
  $packages_manage     = $::gpfs::params::packages_manage,
  $packages_ensure     = $::gpfs::params::packages_ensure,
  $lum_files           = $::gpfs::params::lum_files,
  $lum_hpc_files       = $::gpfs::params::lum_hpc_files,
  $config_manage       = $::gpfs::params::service_manage,
  $file_mode           = $::gpfs::params::file_mode,
  $config_file         = $::gpfs::params::config_file,
  $config_src          = $::gpfs::params::config_src,
  $ssh_private_key_src = $::gpfs::params::ssh_priv_key_src,
  $ssh_hosts           = $::gpfs::params::ssh_hosts,
  $ssl_keys            = $::gpfs::params::ssl_keys,
  $cluster             = $::gpfs::params::cluster,
  $service_manage      = $::gpfs::params::service_manage,
  $service_name        = $::gpfs::params::service_name,
  $service_ensure      = $::gpfs::params::service_ensure,
  $service_enable      = $::gpfs::params::service_enable,
  $ccr_enable          = $::gpfs::params::ccr_enable,
  $ccr_nodes_file      = $::gpfs::params::ccr_nodes_file,
  $ccr_noauth_file     = $::gpfs::params::ccr_noauth_file,
  $ccr_nodes_source    = $::gpfs::params::ccr_nodes_source,
  $ccr_noauth_source   = $::gpfs::params::ccr_noauth_source,
  $ssh_public_key,
  $decrypt_passwd,
) inherits gpfs::params {

  validate_bool($install_manage)
  validate_bool($packages_manage)
  validate_bool($service_manage)
  validate_bool($config_manage)
  validate_bool($ccr_enable)

  if $install_manage and $packages_manage {
    validate_array($packages)
    validate_string($packages_ensure)
  }

  if $install_manage {
    validate_hash($lum_files)
    validate_hash($lum_hpc_files)
  }

  if $config_manage {
    validate_string($file_mode)
    validate_string($decrypt_passwd)
    validate_absolute_path($config_file)
    validate_string($config_src)
    if $ssh_private_key_src != undef {
      validate_string($ssh_private_key_src)
      validate_string($ssh_hosts)
    }
    validate_hash($ssl_keys)
    validate_string($cluster)
    validate_string($ssh_public_key)
    if $ccr_enable {
        validate_absolute_path($ccr_nodes_file)
        validate_absolute_path($ccr_noauth_file)
    }
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
