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

class environment::params {

#### Module variables

  $packages                         = ['bash-completion']
  $packages_ensure                  = 'present'
  $service_user_session             = '/etc/systemd/system/systemd-user-sessions.service'
  $motd_path                        = '/etc/motd'
  $bashrc_config                    = '/etc/bash.bashrc'
  $bashrc_config_src                = 'puppet:///modules/environment/bash.bashrc'
  $profile_config                   = '/etc/profile'
  $profile_config_src               = 'puppet:///modules/environment/profile'
  $profiles_directory               = '/etc/profile.d'
  $ssh_cm_dirprof_src               = 'puppet:///modules/ssh'
  $tty_profile_script               = '000_TTY.sh'
  $tty_profile_script_src           = 'puppet:///modules/environment/000_TTY.sh'
  $promptcommand_profile_script     = '001_prompt_command.sh'
  $promptcommand_profile_script_src = 'puppet:///modules/environment/001_prompt_command.sh'
  $ps1_profilescript                = '001_PS1.sh'
  $ps1_profilescript_src            = 'puppet:///modules/environment/001_PS1.sh'
  $ssh_autogenkeys_script           = 'ssh_keys_autogen.sh'
  $ssh_autogenkeys_script_tpl       = 'environment/ssh_keys_autogen.sh.erb'
  $files_defaults                   = {
    'ensure' => 'present',
    'owner'  => 'root',
    'group'  => 'root',
    'mode'   => '0644',
  }

  $files = {
    "${bashrc_config}"                => {
      source  => $bashrc_config_src,
    },
    "${profile_config}"               => {
      source  => $profile_config_src,
    },
    "${tty_profile_script}"           => {
      path    => "${profiles_directory}/${tty_profile_script}",
      source  => $tty_profile_script_src,
    },
    "${promptcommand_profile_script}" => {
      path    => "${profiles_directory}/${promptcommand_profile_script}",
      source  => $promptcommand_profile_script_src,
    },
    "${ps1_profilescript}"            => {
      path    => "${profiles_directory}/${ps1_profilescript}",
      source  => $ps1_profilescript_src,
    },
  }

  #### Defaults values
  $motd_content = {
    'info'  => [  '',
                  "${::cluster} HPC System",
                  '',
                  $::hostname,
                  '',
            ],
    'legal' => [ '' ],
  }

  $service_user_session_options = {
    'Unit'    => {
      'Description'         => 'Permit User Sessions',
      'Documentation'       => 'man:systemd-user-sessions.service(8)',
      'After'               => 'remote-fs.target network.target',
    },
    'Service' => {
      'Type'                => 'oneshot',
      'RemainAfterExit'     => 'yes',
      'ExecStart'           => '/lib/systemd/systemd-user-sessions start',
      'ExecStop'            => '/lib/systemd/systemd-user-sessions stop',
    },
  }

  $autogen_key_type        = 'rsa'
  $autogen_key_length      = '2048'
  $authorized_users_groups = [ 'users' ]

  $log_commands_enable   = false
  $log_commands_facility = 'local6'
}
