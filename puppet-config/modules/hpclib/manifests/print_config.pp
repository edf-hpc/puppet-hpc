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

# Write the content of a data structure in a configuration file.
#
# @param backup          Save the file before it is replaced.
# @param comments        Character to begin a comment line.
# @param data            Content of the file in Hash or Array form,
# @param exceptions      Key that do not use the ``separator``.
# @param excep_separator Separator to use for  ``exceptions`` keys.
# @param mode            Permissions mode of the file.
# @param owner           User owner of the file.
# @param separator       Character separating the key and value.
# @param style           Config file style.
#   One of: ``ini``, ``keyval``, ``linebyline``, ``yaml``
# @param target           Path of the file to write.
#
define hpclib::print_config(
  $style,
  $data,
  $target          = $title,
  $separator       = '=',
  $comments        = '#',
  $mode            = '0644',
  $owner           = 'root',
  $backup          = undef,
  $exceptions      = [],
  $excep_separator = ' '
) {

  validate_string($style) 
  validate_string($separator) 
  validate_string($comments) 
  validate_numeric($mode) 
  validate_array($exceptions) 
  validate_string($excep_separator)
  validate_string($owner)
  $conf_template = 'hpclib/conf_template.erb'

  case $style {
    ini : {
      validate_hash($data)
    }
    keyval : {
      validate_hash($data)
    }
    linebyline : {
      validate_array($data)
    }
    yaml : {
      validate_hash($data)
    }
    default : {
      fail("The ${style} style is not supported.")
    }
  }

  file { $target :
    content => template($conf_template),
    mode    => $mode,
    owner   => $owner,
    backup  => $backup,
  }

}

