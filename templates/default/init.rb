#!/bin/bash
#
# chkconfig: 35 99 75
# description: start/stop docker-registry
#
# Jean-Francois Theroux <failshell@gmail.com>

### BEGIN INIT INFO
# Provides:       docker-registry
# Required-Start:
# Required-Stop:  $network
# Default-Start:  3 5
# Default-Stop:   0 1 6
# Description:    start/stop docker-registry
### END INIT INFO

# Source function library
. /etc/init.d/functions

prog="docker-registry"

start() {
  touch /var/lock/subsys/docker-registry
  echo -n $"Starting $prog: "
  cd /opt/docker-registry
  SETTINGS_FLAVOR=prod gunicorn -D -k gevent --max-requests 100 --graceful-timeout 3600 -t 3600 -b localhost:5000 -w 8 wsgi:application -p /var/run/docker-registry.pid -u docker -g docker
  RETVAL=$?
  if [ "$RETVAL" == "0" ]; then
    success
  else
    failure
  fi
  echo
}

stop() {
  echo -n $"Stopping $prog: "
  kill `cat /var/run/docker-registry.pid`
  RETVAL=$?
  if [ "$RETVAL" == "0" ]; then
    success
  else
    failure
  fi
  RETVAL=$?
  echo
}

case "$1" in
  start)
    $1
    ;;
  stop)
    $1
    ;;
  *)
    echo $"Usage: $0 (start|stop)"
    exit 2
esac
exit $RETVAL
