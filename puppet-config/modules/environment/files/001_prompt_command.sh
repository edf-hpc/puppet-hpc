#
# Show current tty's name in PROMPT
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#

tty=`tty`
case "$tty" in
	/dev/pts/*)	TTY=`echo $tty | sed 's:/dev/::;s:/::'`
			PROMPT_COMMAND='echo -ne "\033]0;[${USER}-${HOSTNAME%%.*}-$TTY] ${PWD/#$HOME/~}\007"'
			export PROMPT_COMMAND
			;;

	*)		;;
esac

