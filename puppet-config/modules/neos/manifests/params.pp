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

class neos::params {
  $packages = [
    'neos',
    'slurm-llnl-neos-plugin',
  ]
  $packages_ensure = 'installed'

  $config_file = '/etc/neos.conf'
  $config_options_default = {
    'cluster'                => 'mycluster',
    'partitions'             => 'cg',
    'base_dir'               => '${HOME}/.neos',
    'default_scenario'       => 'xfce4',
    'default_resolution'     => '1280x1024',
    'default_window_manager' => 'xfwm4',
    'x_logfile'              => '$base_dir/Xlog_${SLURM_JOB_ID}',
    'vauthfile'              => '$base_dir/vncpass_${SLURM_JOB_ID}',
    'xauthfile'              => '$base_dir/Xauthority_${SLURM_JOB_ID}',
    'ip_pvclient'            => '$base_dir/ippvclient_${SLURM_JOB_ID}',
    'font_path'              => '/usr/share/fonts/X11/misc,/usr/share/fonts/X11/75dpi,/usr/share/fonts/X11/100dpi,/usr/share/fonts/X11/Type1',
    'vnc_x'                  => 'x11vnc',
    'vnc_passwd'             => 'x11vnc',
    'vnc_depth'              => '24',
    'cmd'                    => '$vnc_x -desktop $cluster -xkb -ncache 0 -scale %s -once -display :%s -auth $xauthfile  -rfbport %s -rfbwait 30000 -localhost -rfbauth $vauthfile -oa $x_logfile -noxdamage',
    'salome_path'            => '/opt/salome',
    'paraview_path'          => '/opt/paraview',
    'paraview_resolution'    => '4096x4096',

  }

  $web_apache_file = '/etc/apache2/conf.d/neos.conf'
  $web_dir         = '/usr/local/neos_web'
}

