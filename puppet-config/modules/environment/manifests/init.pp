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
# @param cluster Name of the cluster used in the SSH key names.
class environment (
  $service_user_session         = $environment::params::service_user_session,
  $service_user_session_options = $environment::params::service_user_session_options,
  $motd_content                 = $environment::params::motd_content,
  $authorized_users_groups      = $environment::params::authorized_users_groups,
  $autogen_key_type             = $environment::params::autogen_key_type,
  $autogen_key_length           = $environment::params::autogen_key_length,
  $cluster,
) inherits environment::params {

  validate_string($service_user_session)
  validate_hash($service_user_session_options)
  validate_hash($motd_content)
  validate_string($authorized_users_groups)
  validate_string($autogen_key_type)
  validate_string($autogen_key_length)

  anchor { 'environment::begin': } ->
  class { '::environment::config': } ->
  class { '::environment::service': } ->
  anchor { 'environment::end': }

}
