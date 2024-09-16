#!/usr/bin/env bash

pidof hyprlock && exit

grim -o eDP-1 ~/tmp/lock.png
hyprlock

