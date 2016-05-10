#!/bin/bash
##########################################################################
#  Script                                                                #
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

current_name="$(basename $0 .sh)"

logger -t "${current_name}.info" \
  "Transition: ${instance_type} ${instance_name} to ${target_state} (uid=$(id -u))"

case "${target_state}" in
  "MASTER") systemctl start conman
            ;;
  "BACKUP") systemctl stop conman
            ;;
  "FAULT")  systemctl stop conman
            ;;
  "STOP")   systemctl stop conman
            ;;
  *)        logger -t "${current_name}.error" "Unknown target state: ${target_state}"
            exit 1
            ;;
esac

