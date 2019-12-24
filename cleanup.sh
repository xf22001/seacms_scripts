#!/bin/bash

#================================================================
#   
#   
#   文件名称：cleanup.sh
#   创 建 者：肖飞
#   创建日期：2019年12月17日 星期二 17时21分47秒
#   修改日期：2019年12月24日 星期二 11时05分55秒
#   描    述：
#
#================================================================
function main() {
	find gifs -type f | while read line;do
		local videofile="$(echo "$line" | sed 's/^gifs\///g' | sed 's/\.gif$//g')"
		if [ -f "$videofile" ]; then
			continue;
		fi
		echo "not exist $videofile"
		rm "$line"
	done

	find thumbnails -type f | while read line;do
		local videofile="$(echo "$line" | sed 's/^thumbnails\///g' | sed 's/\.jpg$//g')"
		if [ -f "$videofile" ]; then
			continue;
		fi
		echo "not exist $videofile"
		rm "$line"
	done
}

main $@
