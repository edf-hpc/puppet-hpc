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

class environment::config inherits environment {
  $aliases = $::environment::aliases
  $env_variables = $::environment::env_variables

  hpclib::print_config{ $::environment::login_defs_file :
    style     => 'keyval',
    separator => ' ',
    data      => $::environment::_login_defs_options,
  }

  file {'/etc/motd':
    ensure  => 'present',
    content => template('environment/motd.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file {'/etc/bash.bashrc':
    ensure => 'present',
    source => 'puppet:///modules/environment/bash.bashrc',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file {'/etc/profile':
    ensure => 'present',
    source => 'puppet:///modules/environment/profile',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  debug("Log Commands Enable: ${::environment::log_commands_enable} (${::environment::log_commands_facility})")
  file { '/etc/profile.d/000_config.sh':
    ensure  => 'present',
    content => template('environment/000_config.sh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file {'/etc/profile.d/000_TTY.sh':
    ensure => 'present',
    source => 'puppet:///modules/environment/000_TTY.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file {'/etc/profile.d/001_prompt_command.sh':
    ensure => 'present',
    source => 'puppet:///modules/environment/001_prompt_command.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file {'/etc/profile.d/001_PS1.sh':
    ensure => 'present',
    source => 'puppet:///modules/environment/001_PS1.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/etc/profile.d/010_aliases.sh':
    ensure  => 'present',
    content => template('environment/010_aliases.sh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/profile.d/010_env_variables.sh':
    ensure  => 'present',
    content => template('environment/010_env_variables.sh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/profile.d/ssh_keys_autogen.sh':
    ensure  => 'present',
    content => template('environment/ssh_keys_autogen.sh.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}

