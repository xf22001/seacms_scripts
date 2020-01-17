#!/bin/bash
#set -x

#================================================================
#   
#   
#   文件名称：mv_video.sh
#   创 建 者：肖飞
#   创建日期：2020年01月14日 星期二 08时50分02秒
#   修改日期：2020年01月14日 星期二 08时59分08秒
#   描    述：
#
#================================================================
opt_string="lm"

do_list=0
do_move=0

function process_parameter() {
	local arguments="$1"
	local optarg="$2"
	
	#echo -e "[$0-$FUNCNAME:$LINENO]arguments:$arguments, optarg:$optarg"
	case $arguments in
		l)
			do_list=1
			;;
		m)
			do_move=1
			;;
		*)
			;;
	esac
}


function opt_parse() {
	local args=( "$@" )
	local ret=0
	local current_opt_index=1

	OPTIND=1
	OPTERR=0

	while getopts $opt_string arguments 2>/dev/null; do

		#echo "[$0-$FUNCNAME:$LINENO]\${#args[@]} is ${#args[@]}, \$OPTIND is $OPTIND, \$OPTERR is $OPTERR, \$arguments is $arguments, \$OPTARG is $OPTARG"
		OPTERR=0

		case $arguments in
			"?")
				ret=1
				break
				;;
			*)
				current_opt_index=$OPTIND
				process_parameter "$arguments" "$OPTARG"
				;;
		esac
	done

	#echo "[$0-$FUNCNAME:$LINENO]\${#args[@]} is ${#args[@]}, \$OPTIND is $OPTIND, \$OPTERR is $OPTERR, \$arguments is $arguments, \$OPTARG is $OPTARG"

	if test ${#args[@]} -gt $((current_opt_index - 1)); then
		ret=1
		echo -ne "[$0-$FUNCNAME:$LINENO]Usage:$FUNCNAME \"$opt_string\"\n\t"
		for((index = $current_opt_index - 1; index < ${#args[@]}; index++)); do
			echo -ne " ${args[$index]}"
		done
		echo
	fi

	return $ret
}


function gen_list() {
	find . -maxdepth 1 -type d | while read line; do
		if [ -z "$line" ]; then
			continue
		fi

		if [ "$line" = "." ]; then
			continue
		fi

		if [ "$line" = "./parser" ]; then
			continue
		fi

		if [ "$line" = "./log" ]; then
			continue
		fi

		if [ "$line" = "./torrent" ]; then
			continue
		fi
		echo "$line"
	done > l
}

function du_list() {
	cat l | while read line;do
		du -sh "$line"
	done | sort -h
}

function process_list() {
	cat l | while read line;do
		if [ -d "/media/pi/disk/NSFW/other/videos/$line" ]; then
			echo -ne "exist /media/pi/disk/NSFW/other/videos/$line\nrename to /media/pi/disk/NSFW/other/videos/$line-$(date "+%Y%m%d%H%M%S")\n"
			mv "$line" "/media/pi/disk/NSFW/other/videos/$line-$(date "+%Y%m%d%H%M%S")"
		else
			mv "$line" "/media/pi/disk/NSFW/other/videos/"
		fi
	done
}

function main() {
	opt_parse $@


	gen_list

	if [ $do_list -eq 1 ];then
		du_list
	fi

	if [ $do_move -eq 1 ];then
		process_list
	fi
}

main $@
