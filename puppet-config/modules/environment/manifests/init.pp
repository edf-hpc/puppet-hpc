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

# Setup standard user environment
#
# This class sets up:
# - system shell configuration (/etc/bash.bashrc and /etc/profile.d)
# - systemd-user-session
# - ssh keys generation script for users
# - MOTD
#
# # MOTD
# The MOTD is in two parts that can be modified independently: info and legal.
# The content is provided as a hash in the `motd_content` parameter.
#
# ```
# motd_content => {
#   'info' => [
#     'Welcome to this System',
#     $::hostname,
#   ],
#   'legal' => [
#     'No Trespassing',
#   ],
# }
# ```
#
# @param service_user_session Path of the user session service unit (default:
#           '/etc/systemd/system/systemd-user-sessions.service')
# @param service_user_session_options Hash with content of the user session
#           service unit
# @param motd_content Hash with the MOTD content (see above)
# @param authorized_users_groups Comma separated list of groups that can connect
#           to this node.
# @param autogen_key_type Name of the type of SSH key generated when users logs (
#           default: 'rsa')
# @param autogen_key_length String representing the length of the generated key in
#           bytes (default: '2048')
# @param log_commands_enable Boolean: if true all bash history for all users will
#           be logged (default: false)
# @param log_commands_facility String with the name of the syslog facility to use
#           for command logging (default: 'local6')
# @param login_defs_options Hash with keyval options for the /etc/login.defs
# @param login_defs_file Path of the login.defs file (default: /etc/login.defs)
# @param cluster Name of the cluster used in the SSH key names.
# @param aliases hash with aliases that should be defined in the user profile (
#          default: {})
# @param env_variables hash with environmenat variables that should be defined
#          in the user profile. If the value is not quoted, it will be quoted with
#          simple quotes, if it is already quoted, it will be used as is. There is
#          no guarantee the order in the hash will be maintained. (default: {})
# @param cluster Name of the cluster used in the SSH key names.
class environment (
  $service_user_session         = $::environment::params::service_user_session,
  $service_user_session_options = $::environment::params::service_user_session_options,
  $motd_content                 = $::environment::params::motd_content,
  $authorized_users_groups      = $::environment::params::authorized_users_groups,
  $autogen_key_type             = $::environment::params::autogen_key_type,
  $autogen_key_length           = $::environment::params::autogen_key_length,
  $log_commands_enable          = $::environment::params::log_commands_enable,
  $log_commands_facility        = $::environment::params::log_commands_facility,
  $login_defs_options           = {},
  $login_defs_file              = $::environment::params::login_defs_file,
  $aliases                      = $::environment::params::aliases,
  $env_variables                = $::environment::params::env_variables,
  $cluster,
) inherits environment::params {

  validate_string($service_user_session)
  validate_hash($service_user_session_options)
  validate_hash($motd_content)
  validate_string($authorized_users_groups)
  validate_string($autogen_key_type)
  validate_string($autogen_key_length)
  validate_bool($log_commands_enable)
  validate_string($log_commands_facility)
  validate_hash($aliases)
  validate_hash($env_variables)

  validate_absolute_path($login_defs_file)
  validate_hash($login_defs_options)

  $_login_defs_options = deep_merge($environment::params::login_defs_options_defaults, $login_defs_options)

  anchor { 'environment::begin': } ->
  class { '::environment::config': } ->
  class { '::environment::service': } ->
  anchor { 'environment::end': }

}
