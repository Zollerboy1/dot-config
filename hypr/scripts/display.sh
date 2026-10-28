#!/usr/bin/env bash

for name in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl dispatch "hl.dsp.dpms({ monitor = \"$name\", action = \"$1\" })"
done
