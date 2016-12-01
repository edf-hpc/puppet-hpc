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

# Setup Slurmweb restapi server
#
# The module provides a default racks.xml config file, not to be used in 
# production. You must overide it with a file matching your configuration.
# The module provides a default password for encoded files, not to be used in
# production. You must overide it with a string matching your configuration.
#
# @param packages           Array of packages names
# @param packages_ensure    Install mode (`latest` or `present`) for the
#                           packages (default: `latest`)
# @param config_file        Config file path for the Slurmweb rest api
#                           (default: `/etc/slurm-web/restapi.conf`)
# @param config_options     Content of the `config_file` in a hash
# @param racks_file         Racks.xml configuration file path 
#                           (default: `/etc/slurm-web/racks.xml`)
# @param racks_file_source  Racks.xml file
# @param secret_file        Secret.key path 
#                           (default: `/etc/slurm-web/secret.key`)
# @param secret_file_source secret.key file
# @param ssl_cert_file      Ssl cert file path
# @param ssl_cert_source    Ssl cert
# @param ssl_key_file       Ssl key file path 
# @param ssl_key_source     Encoded ssl key
# @param decrypt_password   String used to decode ended files
#                           (default: 'password', please change it)
# @param slurm_user         System user used by slurm daemons


class slurmweb (
  $packages           = $slurmweb::params::packages,
  $packages_ensure    = $slurmweb::params::packages_ensure,
  $config_file        = $slurmweb::params::config_file,
  $racks_file         = $slurmweb::params::racks_file,
  $racks_file_source  = $slurmweb::params::racks_file_source,
  $secret_file        = $slurmweb::params::secret_file,
  $secret_file_source = $slurmweb::params::secret_file_source,
  $decrypt_passwd     = $slurmweb::params::decrypt_passwd,
  $slurm_user         = $slurmweb::params::slurm_user,
  $ssl_key_file       = $slurmweb::params::ssl_key_file,
  $ssl_cert_file      = $slurmweb::params::ssl_cert_file,
  $ssl_key_source,
  $ssl_cert_source,
  $config_options,
) inherits slurmweb::params {

  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_hash($config_options)
  validate_absolute_path($racks_file)
  validate_string($racks_file_source)
  validate_absolute_path($secret_file)
  validate_string($secret_file_source)
  validate_absolute_path($ssl_cert_file)
  validate_absolute_path($ssl_key_file)
  validate_string($ssl_key_source)
  validate_string($ssl_cert_source)
  validate_string($decrypt_passwd)
  validate_string($slurm_user)

  anchor { 'slurmweb::begin': } ->
  class { '::slurmweb::install': } ->
  class { '::slurmweb::config': } ->
  anchor { 'slurmweb::end': }

}
