#!/bin/bash

#================================================================
#   
#   
#   文件名称：gen_video_thumbnail.sh
#   创 建 者：肖飞
#   创建日期：2019年12月12日 星期四 12时37分42秒
#   修改日期：2019年12月12日 星期四 12时39分58秒
#   描    述：
#
#================================================================
function main() {
	cat log | while read line; do
		if [ ! -f "$line" ]; then
			continue;
		fi

		if [ -f "$line.jpg" ]; then
			continue;
		fi

		ffmpeg -nostdin -ss "0:00:50" -i "$line" -an -vframes 1 "$line.jpg";
	done
}

main $@
