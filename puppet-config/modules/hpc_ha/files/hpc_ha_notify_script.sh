#!/bin/bash
##########################################################################
#  Script used by keepalived and configured by the Puppet hpc_ha module  #
#                                                                        #
#  Configured as the notify script in keepalived configuration, it call  #
#  other scripts in /etc/hpc_ha/$NAME/notify to perform the actions      #
#                                                                        #
#  The scripts are called with the same arguments as this script:        #
#      $1 = "GROUP" or "INSTANCE"                                        #
#      $2 = name of group or instance                                    #
#      $3 = Target state of transition                                   #
#                                                                        #
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

instance_type="${1}"
instance_name="${2}"
target_state="${3}"

args=(
  "--arg=${instance_type}"
  "--arg=${instance_name}"
  "--arg=${target_state}"
)

current_name="$(basename $0 .sh)"
scripts_dir="/etc/hpc_ha/${instance_name}/notify"

logger -t "${current_name}.info" \
  "Transition: ${instance_type} ${instance_name} to ${target_state} (uid=$(id -u))"

case "${target_state}" in
  "MASTER") run-parts "${args[@]}" "${scripts_dir}"
            run-parts "${args[@]}" "${scripts_dir}_master"
            exit 0
            ;;
  "BACKUP") run-parts "${args[@]}" "${scripts_dir}"
            run-parts "${args[@]}" "${scripts_dir}_backup"
            exit 0
            ;;
  "FAULT")  run-parts "${args[@]}" "${scripts_dir}"
            run-parts "${args[@]}" "${scripts_dir}_fault"
            exit 0
            ;;
  "STOP")   run-parts "${args[@]}" "${scripts_dir}"
            run-parts "${args[@]}" "${scripts_dir}_stop"
            exit 0
            ;;
  *)        logger -t "${current_name}.error" "Unknown target state: ${target_state}"
            exit 1
            ;;
esac

