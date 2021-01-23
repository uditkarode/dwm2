#!/bin/dash
while true; do

if [ -z "$(ps -au udit | grep -i dwm)" ]; then
    break
fi

VOLUME="$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')%"
BATTERY="$(acpi | sed "s/,//g" | awk '{if ($3 == "Discharging"){print $4; exit} else {print $4"+"}}' | tr -d "\n")"
MEM="$(free | awk 'FNR == 2 {print $3/($3+$4)*100}')"
WLAN="$(nmcli dev status | grep 'wlp59s0' | grep -v 'p2p-dev' | awk '{ print $3 }')"
DATE="$(date '+%a, %I:%M:%S %p')"

if [ "$WLAN" != "disconnected" ]; then
	WLAN="$(nmcli dev status | grep 'wlp59s0' | grep -v 'p2p-dev' | awk '{ s = ""; for (i = 4; i <= NF; i++) s = s $i " "; print s }')"
fi

sleep 1

xsetroot -name "^c#7cafc2^ ^c#a9a9a9^VOL ^c#ffffff^$VOLUME ^c#7cafc2^[] ^c#a9a9a9^BAT ^c#ffffff^$BATTERY ^c#7cafc2^[] ^c#a9a9a9^MEM ^c#ffffff^$MEM% ^c#7CAFC2^[] ^c#a9a9a9^WLAN ^c#ffffff^$WLAN^c#7cafc2^^b#1089ff^^c#ffffff^ > $DATE < "
done
