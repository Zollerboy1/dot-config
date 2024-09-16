#!/usr/bin/env bash

DEVICE=':*:kbd_backlight'

ICON_DIR="/usr/share/tiny-dfr"

# Get brightness
get_backlight() {
    value="$(brightnessctl -d "$DEVICE" g)"
    maximum="$(brightnessctl -d "$DEVICE" m)"
    echo "$((value * 100 / maximum))"
}

# Get icons
get_icon() {
    current="$(get_backlight)"

    if [[ ("$current" -ge "0") && ("$current" -le "50") ]]; then
        echo "$ICON_DIR/backlight_low.svg"
    elif [[ ("$current" -ge "50") && ("$current" -le "100") ]]; then
        echo "$ICON_DIR/backlight_high.svg"
    fi
}

# Notify
notify_user() {
    kb_backlight="$(get_backlight)"
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Keyboard Brightness: $kb_backlight%" -h int:value:"$kb_backlight"
}

# Increase brightness
inc_backlight() {
    brightnessctl -d "$DEVICE" s 20%+ && notify_user
}

# Decrease brightness
dec_backlight() {
    brightnessctl -d "$DEVICE" s 20%- && notify_user
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

