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

  $aliases = {}
  $env_variables = {}

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

  case $::osfamily {
    'Debian': {
      $login_defs_options_defaults = {
        'MAIL_DIR'         => '/var/mail',
        'FAILLOG_ENAB'     => 'yes',
        'LOG_UNKFAIL_ENAB' => 'no',
        'LOG_OK_LOGINS'    => 'no',
        'SYSLOG_SU_ENAB'   => 'yes',
        'SYSLOG_SG_ENAB'   => 'yes',
        'FTMP_FILE'        => '/var/log/btmp',
        'SU_NAME'          => 'su',
        'HUSHLOGIN_FILE'   => '.hushlogin',
        'ENV_SUPATH'       => 'PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'ENV_PATH'         => 'PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games',
        'TTYGROUP'         => 'tty',
        'TTYPERM'          => '0600',
        'ERASECHAR'        => '0177',
        'KILLCHAR'         => '025',
        'UMASK'            => '022',
        'PASS_MAX_DAYS'    => '99999',
        'PASS_MIN_DAYS'    => '0',
        'PASS_WARN_AGE'    => '7',
        'UID_MIN'          => '1000',
        'UID_MAX'          => '60000',
        'GID_MIN'          => '1000',
        'GID_MAX'          => '60000',
        'LOGIN_RETRIES'    => '5',
        'LOGIN_TIMEOUT'    => '60',
        'CHFN_RESTRICT'    => 'rwh',
        'DEFAULT_HOME'     => 'yes',
        'USERGROUPS_ENAB'  => 'yes',
        'ENCRYPT_METHOD'   => 'SHA512',
      }
    }
    'RedHat': {
      $login_defs_options_defaults = {
        'MAIL_DIR'        => '/var/spool/mail',
        'PASS_MAX_DAYS'   => '99999',
        'PASS_MIN_DAYS'   => '0',
        'PASS_MIN_LEN'    => '5',
        'PASS_WARN_AGE'   => '7',
        'UID_MIN'         => '500',
        'UID_MAX'         => '60000',
        'GID_MIN'         => '500',
        'GID_MAX'         => '60000',
        'CREATE_HOME'     => 'yes',
        'UMASK'           => '077',
        'USERGROUPS_ENAB' => 'yes',
        'ENCRYPT_METHOD'  => 'SHA512',
      }
    }
    default: {
      fail("Unsupported OS Family: ${::osfamily}")
    }
  }

  $login_defs_file = '/etc/login.defs'

}
