#!/bin/bash

#================================================================
#   
#   
#   文件名称：compress_video.sh
#   创 建 者：肖飞
#   创建日期：2019年12月17日 星期二 14时44分06秒
#   修改日期：2020年02月01日 星期六 11时40分09秒
#   描    述：
#
#================================================================
function main() {
	local video_path="$1"
	local new_video_path="$1.compressed.mp4"

	if [ ! -f "$video_path" ]; then
		return;
	fi

	#ffmpeg -i "$video_path" -c:v libx264 -crf 23 -preset veryslow -tune film -c:a aac -strict -2 -b:a 128k "$new_video_path";
	#ffmpeg -i "$video_path" -c:v libx264 -crf 23 -preset veryslow -tune animation -c:a aac -strict -2 -b:a 128k "$new_video_path";
	ffmpeg -threads 4 -nostdin -i "$video_path" -c:v libx264 -crf 20 -preset veryslow -tune film -c:a aac -strict -2 -b:a 128k "$new_video_path";
}

main $@
