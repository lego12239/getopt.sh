#!/bin/bash

#
# GETOPT CODE START
# Copyright (c) 2023 Oleg Nemanov <lego12239@yandex.ru>
# Version: 1.0
# SPDX-License-Identifier: BSD-2-Clause
#
# prms:
#  $1  - callback function name for (opt,arg) pair processing
#  ... - "$@"
#
# ret:
#  NUM - the number of positional arguments used for options(that must be
#        removed from "$@" with help of shift command)
getopts()
{
	local process_opt_cb opt_exists opt_name opt_arg opt_list aidx

	process_opt_cb="$1"
	shift

	opt_exists=1
	opt_name=
	opt_arg=
	opt_list=
	aidx=0
	while [ $opt_exists ]; do
		if [ "$opt_list" ]; then
			opt_name=`printf %s "$opt_list" | cut -c1`
			opt_list=${opt_list#$opt_name}
			opt_name="-$opt_name"
			if [ -z "$opt_list" ]; then
				opt_arg=$2
				shift; aidx=$((aidx + 1))
			else
				opt_arg=$opt_list
			fi
		else
			case $1 in
				--)
					opt_name=
					opt_arg=
					opt_exists=
					shift; aidx=$((aidx + 1))
					;;
				--*)
					opt_name=${1%%=*}
					if [ $opt_name = $1 ]; then
						opt_arg=$2
						shift; aidx=$((aidx + 1))
					else
						opt_arg=${1#*=}
					fi
					;;
				-*)
					opt_name=
					opt_arg=
					opt_list=${1#-}
					;;
				*)
					opt_name=
					opt_arg=
					opt_exists=
					;;
			esac
		fi

		#echo "DBG: '$opt_name', '$opt_arg', '$opt_list'"

		if [ "$opt_name" ]; then
			$process_opt_cb "$opt_name" "$opt_arg"
			if [ $? -eq 1 ]; then
				shift; aidx=$((aidx + 1))
				opt_list=
			fi
		fi
	done

	if [ $aidx -gt 255 ]; then
		echo "getopt: the count of positional arguments with opts and their args is bigger than 255: $aidx" >&2
		exit 1
	fi
	return $aidx
}
#
# GETOPT CODE END
#
