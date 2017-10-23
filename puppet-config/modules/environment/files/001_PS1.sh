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

# If the shell is not interactive there is no prompt to set.
if ! [[ "$-" == *i* ]]
then
  return
fi

#
# Define User's PROMPT
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
if [ "`id -u`" -eq 0 ]; then
	# for root
	# ~~~~~~~~~~~~~~~~
	PS1='[\[\033[01;31m\]\u\[\033[0m\]-\[\033[01;32m\]\h\[\033[0m\]-$TTY] \w # '
else
	# for regular users
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        PS1='[\[\033[01;32m\]\u\[\033[0m\]-\[\033[01;32m\]\h\[\033[0m\]-$TTY] \w $([ -z "$SLURM_JOB_ID" ] || echo "\[\033[01;34m\]SALLOC ")$ \[\033[0m\]'
fi
export PS1
