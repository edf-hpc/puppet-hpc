##########################################################################
#  Environment initialization script for bash PROMPT_COMMAND             #
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
#
# Show current tty's name in PROMPT
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#

tty=`tty`
case "$tty" in
	/dev/pts/*)	
    TTY=`echo $tty | sed 's:/dev/::;s:/::'`
	  PROMPT_COMMAND='echo -ne "\033]0;[${USER}-${HOSTNAME%%.*}-$TTY] ${PWD/#$HOME/~}\007"'
		;;

	*)		;;
esac

#
# Log command (activated in 000_config.sh)
#
if [[ "x${LOG_COMMANDS}" == "xtrue" ]]
then
  log_facility="${LOG_COMMANDS_FACILITY:-local6}"
  log_command="history -a >(tee -a ~/.bash_history | logger -p '${log_facility}.info' -t \"\$USER[\$$] \$SSH_CONNECTION\")"
  if [ -n "${PROMPT_COMMAND}" ]
  then
    PROMPT_COMMAND="${PROMPT_COMMAND};${log_command}"
  else
    PROMPT_COMMAND="${log_command}"
  fi
fi

if [ -n "${PROMPT_COMMAND}" ]
then
  export PROMPT_COMMAND
fi
