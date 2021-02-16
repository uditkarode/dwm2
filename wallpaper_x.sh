#!/bin/dash

if [ -d "$1" ]; then
	cd $1
	target="$(ls $1 | shuf -n 1)"
	echo "$(md5sum ~/.config/wallpaper.png | awk '{ print $1 }')"
	echo "$(md5sum $target | awk '{ print $1 }')"
	while [ "$(md5sum ~/.config/wallpaper.png | awk '{ print $1 }')" = "$(md5sum $target | awk '{ print $1 }')" ]; do
		target="$(ls $1 | shuf -n 1)"
	done
	wal -i "$target"
	xdotool key "Super+F5"
	COLOR="$(xrdb -query | grep -i '*color10' | head -n 1 | sed 's/.*://' | sed 's/^\s//')"
	echo "$COLOR" > ~/.dwm_status_color
elif [ -f "$1" ]; then
	wal -i "$1"
	xdotool key "Super+F5"
	COLOR="$(xrdb -query | grep -i '*color10' | head -n 1 | sed 's/.*://' | sed 's/^\s//')"
fi
