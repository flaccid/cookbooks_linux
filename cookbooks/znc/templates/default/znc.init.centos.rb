#!/bin/bash
#
# znc    Startup script for the znc IRC bouncer daemon
# chkconfig: - 86 15
# description: znc is an IRC bouncer
# processname: znc
# config: /etc/znc.conf
# pidfile: /var/run/znc.pid

# Source function library.
. /etc/init.d/functions

RETVAL=0
ARGS=""
prog="znc"
CONFIG=/etc/znc.conf

if [ -r /etc/default/$prog ]; then
	. /etc/default/$prog
fi

start () {
	echo -n $"Starting $prog: "
	daemon --user znc /usr/bin/znc
	RETVAL=$?
	echo
	[ $RETVAL -eq 0 ] && touch /var/lock/subsys/$prog
}
stop () {
	echo -n $"Stopping $prog: "
	killproc $prog
	RETVAL=$?
	echo
	[ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/$prog
}
# See how we were called.
case "$1" in
  start)
	start
	;;
  stop)
	stop
	;;
  status)
	status $prog
	;;
  restart|reload)
	stop
	start
	;;
  condrestart)
	[ -f /var/lock/subsys/$prog ] && stop && start || :
	;;
  *)
	echo $"Usage: $0 {start|stop|status|restart|reload|condrestart}"
	exit 1
esac

exit $?

# vim:syntax=sh
