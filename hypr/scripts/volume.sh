#!/usr/bin/env bash

ICON_DIR="/usr/share/tiny-dfr"

# Get Volume
get_volume() {
    value=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    value=${value#"Volume: "}
    if [[ "$value" =~ "MUTED" ]]; then
        value=${value%" [MUTED]"}
    fi
    value=$(echo "$value * 100" | bc)
    printf "%.0f\n" "$value"
}

# Get Muted
get_muted() {
    value=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    [[ "$value" =~ "MUTED" ]]
}

# Get icons
get_icon() {
    current=$(get_volume)
    if [[ "$current" -eq "0" ]]; then
        echo "$ICON_DIR/volume_off.svg"
    elif [[ ("$current" -ge "0") && ("$current" -le "50") ]]; then
        echo "$ICON_DIR/volume_down.svg"
    else
        echo "$ICON_DIR/volume_up.svg"
    fi
}

# Notify
notify_user() {
    volume=$(get_volume)
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume: $volume" -h int:value:"$volume"
}

# Increase Volume
inc_volume() {
    wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ && notify_user
}

# Decrease Volume
dec_volume() {
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify_user
}

# Toggle Mute
toggle_mute() {
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    if get_muted; then
        notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$ICON_DIR/volume_off.svg" "Volume Switched OFF"
    else
        notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume Switched ON" -h int:value:"$(get_volume)"
    fi
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
    get_volume
elif [[ "$1" == "--muted" ]]; then
    if get_muted; then
        echo "true"
    else
        echo "false"
    fi
elif [[ "$1" == "--inc" ]]; then
    inc_volume
elif [[ "$1" == "--dec" ]]; then
    dec_volume
elif [[ "$1" == "--toggle-mute" ]]; then
    toggle_mute
else
    get_volume
fi
