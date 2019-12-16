#!/bin/bash

#================================================================
#   
#   
#   文件名称：gen_video_gif.sh
#   创 建 者：肖飞
#   创建日期：2019年12月16日 星期一 14时05分48秒
#   修改日期：2019年12月16日 星期一 16时16分37秒
#   描    述：
#
#================================================================
function main() {
	cat only_filelist | while read line; do
		if [ ! -f "$line" ]; then
			continue;
		fi

		local tn_path="gifs/$line.gif"

		if [ -f "$tn_path" ]; then
			continue;
		fi

		local tn_dir=$(dirname "$tn_path")
		mkdir -p "$tn_dir";

		local duration=$(ffmpeg -nostdin -i "$line" 2>&1 | grep "Duration" | sed 's/.*Duration: //g' | sed 's/\..*//g')

		if [ -z "duration" ]; then
			echo "$line get duration error!";
			return;
		fi

		index=0;

		python gen_frame_pos_list.py "$duration" | while read start_pos;do
			ffmpeg -nostdin -ss "$start_pos" -i "$line" -vf "scale=iw/3:-1" -an -vframes 1 "$tn_path.$index.jpg";
			#((index++));
			let index=index+1;
		done

		ffmpeg -r 2 -i "$tn_path.%d.jpg" "$tn_path";

		index=0
		python gen_frame_pos_list.py "$duration" | while read start_pos;do
			rm "$tn_path.$index.jpg";
			((index++));
		done
	done
}

main $@
