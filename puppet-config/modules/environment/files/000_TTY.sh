#
# Initialize the environment variable TTY
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#

tty=`tty`
case "$tty" in
	/dev/tty*)	TTY=`echo $tty | sed 's:/dev/::'`
			;;

	/dev/pts/*)	TTY=`echo $tty | sed 's:/dev/::;s:/::'`
			;;

	/dev/syscon)	TTY="syscon"
			;;

	*)		TTY="unknown"
			;;
esac

export TTY
