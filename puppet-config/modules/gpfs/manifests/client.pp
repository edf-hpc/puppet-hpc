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

# Deploys the GPFS client. 
# 
# @param cl_dir_mode	      Permissions for directories (Default: '755)
# @param cl_file_mode	      Permissions for files (Default: '640')
# @param cl_decrypt_passwd    Password to decrypt encrypted files 
#                             (Default: 'password')
# @param cl_packages          Packages to install for the client
#                             (Default: ['gpfs.base', 'gpfs.msg.en-us', 
#                             'gpfs.lum', 'gpfs.gskit', 
#                             'gpfs.gpl-3.16.0-4-amd64'])
# @param cl_packages_ensure   State of packages on the system 
#                             (Default: 'present']
# @param cl_config_dir        List (array) of directory paths that must exist
#                             to configure gpfs when installing the client
#                             (Default: ['/var/mmfs', '/var/mmfs/gen', 
#                             '/var/lock', '/var/lock/subsys', '/usr/lpp',
#                             '/usr/lpp/mmfs', '/usr/lpp/mmfs/lib', 
#                             '/var/mmfs/ssl', '/var/mmfs/ssl/stage',])
# @param cl_config            Absolute path of the configuration file for 
#                             the gpfs client (Default: '/var/mmfs/gen/mmsdrfs')
# @param cl_config_src        Path of the encrypted source of the configuration
#                             file (Default: 'gpfs/mmsdrfs.enc')
# @param cl_key               Absolute path of the SSL key file used by the gpfs
#                             client for internal communications
#                             (Default:'/var/mmfs/ssl/stage/genkeyData1') 
# @param cl_key_src           Path of the encrypted source of the SSL key file
#                             (Default: 'gpfs/genkeyData1.enc')
# @param cluster              Name of the current cluster (Default: 'cluster')
# @param service              Name of the service (Default: 'gpfs')
# @param service_override_options
#                             Hash to configure the service
# @param public_key           Public authorized key for SSH communications to 
#                             add for the root user  
class gpfs::client (
  $cl_dir_mode              = $gpfs::params::cl_dir_mode,
  $cl_file_mod              = $gpfs::params::cl_file_mode,
  $cl_decrypt_passwd        = $gpfs::params::cl_decrypt_passwd,
  $cl_packages              = $gpfs::params::cl_packages,
  $cl_packages_ensure       = $gpfs::params::cl_packages_ensure,
  $cl_config_dir            = $gpfs::params::cl_config_dir,
  $cl_config                = $gpfs::params::cl_config,
  $cl_config_src            = $gpfs::params::cl_config_src,
  $cl_key                   = $gpfs::params::cl_key,
  $cl_key_src               = $gpfs::params::cl_key_src,
  $cluster                  = $gpfs::params::cluster,
  $service                  = $gpfs::params::service,
  $service_override_options = $gpfs::params::service_override_options,
  $public_key,
) inherits gpfs::params {

  validate_string($cl_dir_mode)
  validate_string($cl_file_mod)
  validate_string($cl_decrypt_passwd)
  validate_array($cl_packages)
  validate_string($cl_packages_ensure)
  validate_array($cl_config_dir)
  validate_absolute_path($cl_config)
  validate_string($cl_config_src)
  validate_absolute_path($cl_key)
  validate_string($cl_key_src)
  validate_string($cluster)
  validate_string($public_key)
  validate_string($service)
  validate_hash($service_override_options)

  anchor { 'gpfs::client::begin': } ->
  class { '::gpfs::client::install': } ->
  class { '::gpfs::client::config': } ->
  class { '::gpfs::client::service': } ->
  anchor { 'gpfs::client::end': }

}
