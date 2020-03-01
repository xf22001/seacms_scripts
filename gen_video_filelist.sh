#!/bin/bash

#================================================================
#   
#   
#   文件名称：gen_video_filelist.sh
#   创 建 者：肖飞
#   创建日期：2019年12月12日 星期四 12时40分50秒
#   修改日期：2020年03月01日 星期日 14时23分03秒
#   描    述：
#
#================================================================
function main() {
	find . -type f | grep -i "\.avi$\|\.mp4$\|\.wmv$\|\.rm$\|\.rmvb$" | while read line; do
		du -sh "$line";
	done | sort -h | uniq > size_filelist

	sed 's/^.*\t//g' size_filelist > only_filelist

	cat only_filelist | while read line;do
		ts=$(stat -c "%Y" "$line");
		filepath=$(echo "$line" | sed 's:\./:/:g')
		echo -e "$ts,$filepath"
	done | sort -h > filelist
}

main $@
