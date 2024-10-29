#!/usr/bin/env bash

pidof hyprlock && exit

monitors_config=""
for monitor in $(hyprctl monitors -j | jq -r '.[].name'); do
    grim -o $monitor ~/tmp/lock_$monitor.png

    monitors_config+="background {\\n\
    monitor = $monitor\\n\
    path = ~/tmp/lock_$monitor.png\\n\
    color = rgb(54, 12, 106)\\n\
\\n\
    blur_passes = 5\\n\
    blur_size = 1\\n\
    brightness = 0.4\\n\
}\\n\
\\n"
done

cp ~/.config/hypr/hyprlock.conf ~/tmp/hyprlock.conf

sed -z "s|# monitors\\n\\n|$monitors_config|g" -i ~/tmp/hyprlock.conf

hyprlock -c ~/tmp/hyprlock.conf

