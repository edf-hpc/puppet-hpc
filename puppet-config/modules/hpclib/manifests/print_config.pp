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
# # Styles
# ## entries
#
# For ``ini`` and ``keyval``, an entry is a structure that can have the following forms:
#
# **Direct string**:
#
# ```
# "key" => "value"
# ```
#
# If the separator is ``=``, it will be written as:
#
# ```
# key=value
# ```
#
# **Commented value**:
#
# ```
# "somekey" => {
#   "comment" => "Some Comment",
#   "value"   => "somevalue",
# }
# ```
#
# If the separator is ``=``, it will be written as:
#
# ```
# #Some Comment
# somekey=somevalue
# ```
#
# Comment can be undefined or ommited.
#
# ##``ini``:
# ``data`` is a hash of sections pointing to an array of entries
#
# ```
# "SectionA" => {
#   "key1" => {
#      "value"   => "a,b,c,d",
#      "comment" => "Ordered letters",
#    },
#   "key2" => {
#      "value"   => "1,2,3,4",
#      "comment" => "Ordered numbers",
#    }
# },
# "SectionB" => {
#   "key1" => {
#      "value"   => "a,c,d",
#      "comment" => "Ordered letters",
#   },
#   "key3" => {
#      "value"   => "1,2",
#      "comment" => "Ordered numbers",
#    },
# }
# ```
#
# If the separator is ``=``, it will be written as:
#
# ```ini
# [SectionA]
# #Ordered letters
# key1=a,b,c,d
# #Ordered numbers
# key2=1,2,3,4
#
# [SectionB]
# #Ordered letters
# key1=a,c,d
# #Ordered numbers
# key3=1,2
#
# ```
#
# ##``keyval``:
# ``data`` is a hash of entries.
#
# ##``linebyline``:
# ``data`` is an array of lines dumped into the file
#
# ##``yaml``:
# Dump the content of ``data`` as a YAML file.
#
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
# @param upper_case_keys Transform keys to upper case
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
  $excep_separator = ' ',
  $upper_case_keys = false,
) {

  validate_string($style)
  validate_string($separator)
  validate_string($comments)
  validate_numeric($mode)
  validate_array($exceptions)
  validate_string($excep_separator)
  validate_string($owner)
  validate_bool($upper_case_keys)

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

