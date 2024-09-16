#!/usr/bin/env bash

ICON_DIR="/usr/share/tiny-dfr"

# Get brightness
get_backlight() {
    value="$(brightnessctl g)"
    maximum="$(brightnessctl m)"
    echo "$((value * 100 / maximum))"
}

# Get icons
get_icon() {
    current="$(get_backlight)"

    if [[ ("$current" -ge "0") && ("$current" -le "50") ]]; then
        echo "$ICON_DIR/brightness_low.svg"
    elif [[ ("$current" -ge "50") && ("$current" -le "100") ]]; then
        echo "$ICON_DIR/brightness_high.svg"
    fi
}

# Notify
notify_user() {
    backlight="$(get_backlight)"
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Brightness: $backlight%" -h int:value:"$backlight"
}

# Increase brightness
inc_backlight() {
    brightnessctl s +5% && notify_user
}

# Decrease brightness
dec_backlight() {
    brightnessctl s 5%- && notify_user
}

# Execute accordingly
if [[ "$1" == "--get" ]]; then
    get_backlight
elif [[ "$1" == "--inc" ]]; then
    inc_backlight
elif [[ "$1" == "--dec" ]]; then
    dec_backlight
else
    get_backlight
fi
