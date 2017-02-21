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

# Install the clara cluster administration tool
#
# @param packages            packages list
# @param packages_ensure     packages install mode
# @param config_file         Main configuration file path (`config.ini`)
# @param repos_file          Repository declaration file path (`repos.ini`)
# @param repos_options       Content of the `repos_file` in a hash
# @param keyring_file        Encoded keyring secret file
#                            (`cluster_keyring.secret.gpg.enc`) path
# @param keyring_source      Encoded keyring secret file
#                            (`cluster_keyring.secret.gpg.enc`) source
# @param password_file       Master password file path
# @param password_options    Master password file content in a hash
# @param common_options      Content of the common section of `config.ini`
#                            in a hash, merged with default values
# @param repo_options        Content of the common section of `config.ini` in
#                            a hash, merged with default values
# @param ipmi_options        Content of the common section of `config.ini`
#                            in a hash, merged with default values
# @param images_options      Content of the common section of `config.ini`
#                            in a hash, merged with default values
# @param p2p_options         Content of the common section of `config.ini`
#                            in a hash, merged with default values
# @param build_options       Content of the common section of `config.ini`
#                            in a hash, merged with default values
# @param slurm_options       Content of the whole `config.ini` in a hash,
#                            merged with previous parameters
# @param apt_ssl_cert_source Optional source of APT client SSL certificate for
#                            chroot plugin (default: undef)
# @param apt_ssl_cert_file   Absolute path to APT client SSL certificate for
#                            chroot plugin (default:
#                            '/etc/certificates/clara-apt.pem'),
# @param apt_ssl_key_source  Optional source of APT client SSL key for chroot
#                            plugin (default: undef)
# @param apt_ssl_key_file    Absolute path to APT client SSL key for chroot
#                            plugin (default:
#                            '/etc/certificates/clara-apt.key'),
# @param virt_file           Virt options file path (`virt.ini`)
# @param virt_options        Content of the `virt_file` in a hash
# @param virt_tpl_hpc_files  Template files to create (resources to define with
#                            hpclib::hpc_files)
# @param decrypt_password    Encryption password for encoded files (no default)
class clara (
  $packages            = $::clara::params::packages,
  $packages_ensure     = $::clara::params::packages_ensure,
  $config_file         = $::clara::params::config_file,
  $repos_file          = $::clara::params::repos_file,
  $repos_options       = $::clara::params::repos_options,
  $keyring_file        = $::clara::params::keyring_file,
  $keyring_source      = $::clara::params::keyring_source,
  $password_file       = $::clara::params::password_file,
  $password_options    = {},
  $common_options      = {},
  $repo_options        = {},
  $ipmi_options        = {},
  $images_options      = {},
  $p2p_options         = {},
  $build_options       = {},
  $slurm_options       = {},
  $config_options      = {},
  $chroot_options      = {},
  $apt_ssl_cert_source = $::clara::params::apt_ssl_cert_source,
  $apt_ssl_cert_file   = $::clara::params::apt_ssl_cert,
  $apt_ssl_key_source  = $::clara::params::apt_ssl_key_source,
  $apt_ssl_key_file    = $::clara::params::apt_ssl_key,
  $virt_file           = $::clara::params::virt_file,
  $virt_options        = {},
  $virt_tpl_hpc_files  = {},
  $live_dirs           = $::clara::params::live_dirs_defaults,
  $live_files          = $::clara::params::live_files_defaults,
  $decrypt_passwd,
) inherits clara::params {
  validate_array($packages)
  validate_string($packages_ensure)
  validate_absolute_path($config_file)
  validate_absolute_path($repos_file)
  validate_absolute_path($repos_file)
  validate_absolute_path($keyring_file)
  validate_string($keyring_source)
  validate_absolute_path($password_file)
  validate_hash($password_options)
  validate_hash($repos_options)
  validate_hash($common_options)
  validate_hash($repo_options)
  validate_hash($ipmi_options)
  validate_hash($images_options)
  validate_hash($p2p_options)
  validate_hash($build_options)
  validate_hash($slurm_options)
  validate_absolute_path($virt_file)
  validate_hash($virt_options)
  validate_hash($virt_tpl_hpc_files)
  validate_hash($live_dirs)
  validate_hash($live_files)
  validate_hash($chroot_options)

  $_common_options = deep_merge($::clara::params::common_options_defaults, $common_options)
  $_repo_options   = deep_merge($::clara::params::repo_options_defaults,   $repo_options)
  $_ipmi_options   = deep_merge($::clara::params::ipmi_options_defaults,   $ipmi_options)
  $_images_options = deep_merge($::clara::params::images_options_defaults, $images_options)
  $_p2p_options    = deep_merge($::clara::params::p2p_options_defaults,    $p2p_options)
  $_build_options  = deep_merge($::clara::params::build_options_defaults,  $build_options)
  $_slurm_options  = deep_merge($::clara::params::slurm_options_defaults,  $slurm_options)
  $_chroot_options = deep_merge($::clara::params::chroot_options_defaults, $chroot_options)
  $_virt_options   = deep_merge($::clara::params::virt_options_defaults,   $virt_options)

  $generic_config_options = {
    'common' => $::clara::_common_options,
    'repo'   => $::clara::_repo_options,
    'ipmi'   => $::clara::_ipmi_options,
    'images' => $::clara::_images_options,
    'p2p'    => $::clara::_p2p_options,
    'build'  => $::clara::_build_options,
    'slurm'  => $::clara::_slurm_options,
    'chroot' => $::clara::_chroot_options,
  }

  $_config_options = merge($generic_config_options, $config_options)

  $_password_options = merge($::clara::params::password_options_default, $password_options)

  if $apt_ssl_cert_source {
    validate_string($apt_ssl_cert_source)
    validate_absolute_path($apt_ssl_cert_file)
  }

  if $apt_ssl_key_source {
    validate_string($apt_ssl_key_source)
    validate_absolute_path($apt_ssl_key_file)
    validate_string($decrypt_password)
  }

  anchor { 'clara::begin': } ->
  class { '::clara::install': } ->
  class { '::clara::config': } ->
  anchor { 'clara::end': }

}
