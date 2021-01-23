CURRENT_CARD='alsa_card.pci-0000_00_1f.3'

SPEAKER_PROFILE='output:analog-stereo'
HDMI_PROFILE='output:hdmi-stereo-extra2'

CURRENT_PROFILE="$(pacmd list-cards | grep 'active profile')"

if [ ! -z "$(echo "$CURRENT_PROFILE" | grep "$SPEAKER_PROFILE")" ]; then
  pactl set-card-profile "$CURRENT_CARD" "$HDMI_PROFILE"
elif [ ! -z "$(echo "$CURRENT_PROFILE" | grep "$HDMI_PROFILE")" ]; then
  pactl set-card-profile "$CURRENT_CARD" "$SPEAKER_PROFILE"
fi

