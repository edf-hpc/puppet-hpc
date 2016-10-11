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
  validate_string($authorized_users_group)
  validate_string($autogen_key_type)
  validate_string($autogen_key_length)

  anchor { 'environment::begin': } ->
  class { '::environment::config': } ->
  class { '::environment::service': } ->
  anchor { 'environment::end': }

}
