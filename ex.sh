#!/bin/bash

source ./libgetopt.sh

show_usage()
{
	echo "Usage: `basename $0` [OPTIONS] DB"
	echo ""
	echo " OPTIONS:"
	echo "  -h,--help       show help"
	echo "  -H,--host=HOST  set host name"
	echo "  -p,--port=PORT  set tcp port"
	echo "  -U,--user=NAME  set user name"
	echo "  -P,--pass=PASS  set user pass"
	echo "  -v,--verbose    be more verbose"
	echo "  -d,--debug      show debug info"
}

process_opt()
{
	local RET

	RET=0
	case "$1" in
		-h|--help)
			show_usage
			exit
			;;
		-H|--host)
			host="$2"
			RET=1
			;;
		-p|--port)
			port="$2"
			RET=1
			;;
		-U|--user)
			dbuser="$2"
			RET=1
			;;
		-P|--pass)
			dbpass="$2"
			RET=1
			;;
		-v|--verbose)
			verbose=1
			;;
		-d|--debug)
			debug=1
			;;
		-*)
			echo "Wrong option: $1"
			show_usage
			exit
			;;
	esac

	return $RET
}

getopts process_opt "$@"
shift $?

if [ -z $host ]; then
	host=DEFAULT.VALUE
fi

db=$1
if [ -z $db ]; then
	echo DB must be specified!
fi

echo host = $host , port = $port, verbose = $verbose, debug = $debug, db = $db
