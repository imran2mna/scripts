#!/bin/bash

# system configuration
PORT=9080
JAVA_PATH=./jre_8/bin/java
START_DELAY=5
STOP_DELAY=2

# errors
ARG_ERR=1
RUN_ERR=2

# usage instruction
[ $# -ne 1 ] && echo "Usage: $0 [ start | stop | status ]" && exit ${ARG_ERR}
pid=$(ss -plt | grep ${PORT} | cut -f 2 -d ',' | cut -f 2 -d '=')

case $1 in

	start)
		cd $(dirname $0)
		if [ -z $pid ]; then
			nohup ${JAVA_PATH} -jar jenkins.war --httpPort=${PORT} 2> /dev/null &
			sleep ${START_DELAY}
		else 
			echo "application already running, pid $pid" && exit ${RUN_ERR}
		fi	
		pid=$(ss -plt | grep ${PORT} | cut -f 2 -d ',' | cut -f 2 -d '=')
		[ ! -z $pid ] && echo "Listening on $PORT, pid $pid "
		;;

	stop)
		[ ! -z $pid ] && kill $pid && echo "stopping signal sent to $pid " && sleep ${STOP_DELAY}
		pid=$(ss -plt | grep ${PORT} | cut -f 2 -d ',' | cut -f 2 -d '=')
		[ -z $pid ] && echo "application stopped" || ( echo "failed to stop..." && exit ${RUN_ERR} ) 
		;;

	status)
		[ ! -z $pid ] && echo "Listening on $PORT, pid $pid" || ( echo "application stopped" && exit ${RUN_ERR} )
		;;

	*)
		echo "Unknown Operation" && echo "Usage: $0 [ start | stop | status ]" && exit ${ARG_ERR}
		;;
esac
