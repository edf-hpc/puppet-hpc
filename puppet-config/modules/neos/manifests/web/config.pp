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

class neos::web::config {

  ## construct the server.pvsc (Paraview)
  file { $::neos::web::web_dir:
    ensure => directory,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  # Extract some variables to use them in the template
  $cluster_name = $::neos::web::_neos_options['cluster']['name']
  $partition    = $::neos::web::_neos_options['cluster']['partition']
  $pv_options   = $::neos::web::_neos_options['paraview']
  if is_hash($pv_options) {
    $paraview_path = $::neos::web::_neos_options['paraview']['paraviewpath']
  } else {
    $paraview_path = '/usr'
  }

  if $::neos::web::paraview_source {
    $_paraview_content = undef
  } else {
    if $::neos::web::paraview_content {
      $_paraview_content = $::neos::web::paraview_content
    } else {
      $_paraview_content = template('neos/web_paraview_server.pvsc.erb')
    }
  }

  file { "${::neos::web::web_dir}/server.pvsc":
    ensure  => present,
    source  => $::neos::web::paraview_source,
    content => $_paraview_content,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
  }

  ## Setup the apache configuration
  include ::apache
  file { $::neos::web::apache_file:
    ensure  => present,
    content => template('neos/web_apache.conf.erb'),
    notify  => Class['apache::service'],
  }
}

