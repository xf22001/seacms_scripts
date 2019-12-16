#!/bin/bash

#================================================================
#   
#   
#   文件名称：gen_video_thumbnail.sh
#   创 建 者：肖飞
#   创建日期：2019年12月12日 星期四 12时37分42秒
#   修改日期：2019年12月16日 星期一 13时03分49秒
#   描    述：
#
#================================================================
function main() {
	cat only_filelist | while read line; do
		if [ ! -f "$line" ]; then
			continue;
		fi

		local tn_path="thumbnails/$line.jpg"

		if [ -f "$tn_path" ]; then
			continue;
		fi

		local tn_dir=$(dirname "$tn_path")
		mkdir -p "$tn_dir"

		ffmpeg -nostdin -ss "0:00:50" -i "$line" -an -vframes 1 "$tn_path";
	done
}

main $@
