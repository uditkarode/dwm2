#!/bin/zsh

while true; do

FETCH_START="$(($(date +%s%N)/1000000))"

if [ -z "$(ps -au $USER | grep -i dwm)" ]; then
    break
fi

VOLUME="$(pamixer --get-volume)%"
BATTERY="$(acpi | sed "s/,//g" | awk '{if ($3 == "Discharging"){print $4; exit} else {print $4"+"}}' | tr -d "\n")"
MEM="$(free | awk 'FNR == 2 {print $3/($3+$4)*100}')"
WLAN="$(nmcli dev status | grep 'wlp59s0' | grep -v 'p2p-dev' | awk '{ print $3 }')"
DATE="$(date '+%a, %I:%M:%S %p')"
POWER="$(powercheck)"

COLOR="$(cat ~/.dwm_status_color)"
SINK="$(pactl info | grep -i 'sink' | sed 's/Default Sink: //')"
SOURCE="$(pactl info | grep -i 'source' | sed 's/Default Source: //')"

SPEAKER_SINK="alsa_output.pci-0000_00_1f.3.analog-stereo"
HDMI_SINK="alsa_output.pci-0000_00_1f.3.hdmi-stereo-extra2"

AUDIO_DEVICE="["

if [ "$SINK" = "$SPEAKER_SINK" ]; then
  AUDIO_DEVICE="${AUDIO_DEVICE}SPKR"
elif [ "$SINK" = "$HDMI_SINK" ]; then
  AUDIO_DEVICE="${AUDIO_DEVICE}HDMI"
fi
if [ -z "$(echo "$SOURCE" | grep 'monitor')" ]; then
  # the input device is a microphone of some sort
  AUDIO_DEVICE="${AUDIO_DEVICE}+MIC"
fi

AUDIO_DEVICE="${AUDIO_DEVICE}]"

if [ "$(pamixer --get-mute)" = "true" ]; then
	AUDIO_DEVICE="${AUDIO_DEVICE}[MUTE]"
fi

if [ "$WLAN" != "disconnected" ]; then
	WLAN="$(nmcli dev status | grep 'wlp59s0' | grep -v 'p2p-dev' | awk '{ s = ""; for (i = 4; i <= NF; i++) s = s $i " "; print s }')"
fi

FETCH_END="$(($(date +%s%N)/1000000))"
DIFF="$(( $FETCH_END - $FETCH_START ))"

if [ "$DIFF" -lt "1000" ] && [ "$DIFF" -gt "0" ]; then
	SLEEP_TIME="$(( 1000 - $DIFF ))"
	SLEEP_TIME="$(( $SLEEP_TIME.0 / 1000 ))"
	sleep "$SLEEP_TIME"
fi

xsetroot -name "^c#7cafc2^ ^c#a9a9a9^VOL ^c#ffffff^$VOLUME $AUDIO_DEVICE ^c$COLOR^[] ^c#a9a9a9^BAT ^c#ffffff^$BATTERY ^c$COLOR^[] ^c#a9a9a9^PWR ^c#ffffff^$POWER^c$COLOR^[] ^c#a9a9a9^MEM ^c#ffffff^$MEM% ^c$COLOR^[] ^c#a9a9a9^WLAN ^c#ffffff^$WLAN^c#7cafc2^^b$COLOR^^c#ffffff^ > $DATE < "
done
