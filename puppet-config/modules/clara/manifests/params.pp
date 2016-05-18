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

class clara::params {
  $packages = [
    'clara'
  ]
  $packages_ensure = 'installed'

  $config_file = '/etc/clara/config.ini'
  $repos_file = '/etc/clara/repos.ini'
  $repos_options = {}

  $keyring_file   = '/etc/clara/cluster_keyring.secret.gpg.enc'
  $keyring_source = 'puppet:///modules/clara/cluster_keyring.secret.gpg.enc'

  $password_file            = '/etc/clara/master_password'
  $password_options_default = {
    'ASUPASSWD'   => 'password',
    'IMMUSER'     => 'USERID',
    'IMMPASSWORD' => 'password',
  }
  
  $common_options_default = {
    'master_passwd_file'    => {
      comment => 'File: Contains the usernames and passwords needed by the scripts',
      value   => $password_file,
    },
    'allowed_distributions' => {
      comment => 'List: Posible distributions to be used if we\'re using multi-distro',
      value   => 'calibre9,calibre8,calibre7',
    },
    'default_distribution'  => {
      comment => 'String: Name of your Debian derivative by default',
      value   => 'calibre9',
      },
    'origin'                => {
      comment => 'String: Name of the team or departament maintaining the repository',
      value   => 'HPC-Team',
    },
  }

  $repo_options_default =  {
    'clustername'    => {
      comment => 'String: Name of your cluster or project.',
      value   => 'HPCCluster',
    },
    'gpg_key'        => {
      comment => 'String: GPG key that will be used to sign the repository by reprepro.',
      value   => 'CHANGEME',
    },
    'stored_enc_key' => {
      comment => 'Path: File containing the private key ("gpg_key") used to sign the repository',
      value   => $keyring_file,
    },
    'sections'       => {
      comment => 'List: list of sections debmirror should sync (used by clara repo sync)',
      value   => 'main,contrib,non-free,main/debian-installer',
    },
    'archs'          => {
      comment => 'List: list of architectures debmirror should sync (used by clara repo sync)',
      value   => 'i386,amd64',
    },
    'mirror_root'    => {
      comment => 'Path: Directory containing the local copy of the remote mirror',
      value   => "/var/www/html",
    },
    'method'         => {
      comment => 'String: Specify the method that debmirror should use to download files: ftp, http, https, or rsync',
      value   => 'http',
    }
  }

  $ipmi_options_default = {
    'conmand'               => {
      comment                 => '',
      value                   => 'localhost',
    },
    'port'               => {
      comment                 => '',
      value                   => '7890',
    },
    'parallel'               => {
      comment                 => '',
      value                   => '16',
    },
  }

  $images_options_default = {
    'files_to_remove'      => {
      comment => 'List: Files to be removed from the image',
      value   => '/etc/udev/rules.d/70-persistent-net.rules,/root/.bash_history,/etc/hostname',
    },
    'etc_hosts'            => {
      comment => 'List: contains the list of host we want to add to /etc/hosts',
      value   => '',
    },
    'extra_packages_image' => {
      comment => 'List: Extra packages we want to add in the image',
      value   => '',
    },
  }

  $p2p_options_default = {
    'seeders'          => {
      comment => 'Nodeset: list of host seeding',
      value   => $p2p_seeders,
    },
    'trackers'         => {
      comment => 'Nodeset: list of hosts tracking',
      value   => $p2p_trackers,
    },
    'trackers_port'    => {
      comment => 'String: port used to check the trackers',
      value   => '6881',
    },
    'trackers_schema'  => {
      comment => 'String: protocol used to check the trackers',
      value   => 'http',
    },
    'tracking_service' => {
      comment => 'String: name of tracking service',
      value   => 'opentracker',
    },
    'seeding_service'  => {
      comment => 'String: name of seeding service',
      value   => 'ctorrent',
    },
    'init_status'      => {
      comment => 'String: command to check the status of a service ({0} will be replaced by the service name)',
      value   => 'systemctl status {0}',
    },
    'init_start'       => {
      comment => 'String: command to start of a service ({0} will be replaced by the service name)',
      value   => 'systemctl start {0}',
    },
    'init_stop'        => {
      comment => 'String: command to stop a service ({0} will be replaced by the service name)',
      value   => 'systemctl stop {0}',
    },
  }

  $build_options_default = {
    'target_dists'   => {
      comment => 'List: Possible distributions, it is a list of pairs long name and short name',
      value   => 'calibre7:c7,calibre8:c8,calibre9:c9',
    },
    'cowbuilder_bin' => {
      comment => 'File: cowbuilder binary',
      value   => '/usr/sbin/cowbuilder-generic',
    },
  }

  $slurm_options_default = {
    'script_slurm_health' => {
      comment => 'File: A script to be run to check the nodes\' health',
      value   => '/usr/sbin/nhc',
    },
  }

}

