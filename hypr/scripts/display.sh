#!/usr/bin/env bash

for name in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl dispatch dpms $1 $name
done

