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

# If the shell is not interactive there is no prompt command to set.
if ! [[ "$-" == *i* ]]
then
  return
fi

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

  *)
    ;;
esac

#
# Log command (activated in 000_config.sh)
#
if [[ "x${LOG_COMMANDS}" == "xtrue" ]]
then
  # Verify that the default HISTFILE (in the home) is writable,
  # this can be not the case when there is no home for the user.
  if ! touch "${HISTFILE}" 2> /dev/null
  then
    export HISTFILE="$(mktemp --tmpdir ${USER}_histfile_XXXXXXXXX)"
  fi

  log_facility="${LOG_COMMANDS_FACILITY:-local6}"
  if ! [ -f "${HISTFILE}" ]
  then
    logger -p '${log_facility}.info' -t "$USER[$$] $SSH_CONNECTION" "No history file '${HISTFILE}', can't log user commands for this shell."
  else
    log_command="history -a >(tee -a ${HISTFILE} | logger -p '${log_facility}.info' -t \"\$USER[\$$] \$SSH_CONNECTION\$(if [ -n \$SUDO_USER ] ; then echo \" sudo_user=\$SUDO_USER[\$PPID]\" ; fi)\")"
    if [ -n "${PROMPT_COMMAND}" ]
    then
      PROMPT_COMMAND="${PROMPT_COMMAND};${log_command}"
    else
      PROMPT_COMMAND="${log_command}"
    fi
  fi
fi

if [ -n "${PROMPT_COMMAND}" ]
then
  export PROMPT_COMMAND
fi
