#!/usr/bin/env ruby
##########################################################################
#  Puppet configuration file                                             #
#                                                                        #
#  Copyright (C) 2016-2017 EDF S.A.                                      #
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

require 'hpc/source'

# @param source source or array of sources that should be loaded
Puppet::Parser::Functions::newfunction(
  :hpc_source_file, 
  :type => :rvalue,
  :arity => 1,
  :doc => "Loads a file from a source (module, file://, http://...) and returns the data") do |args|
  raise ArgumentError, ("hpc_source_file(): wrong number of arguments (#{args.length}; must be 1") if args.length != 1

  source = args[0]

  raise ArgumentError, ('hpc_source_file(): First argument (source) must be an Array or a String') unless source.kind_of?(Array) or source.is_a?(String)

  debug "Retrieving content of #{source}"
  result = hpc_source_file(source)

  begin
    result
  rescue Puppet::ParseError => internal_error
    if internal_error.original.nil?
      raise internal_error
    else
      raise internal_error.original
    end
  end
end
