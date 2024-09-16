#!/usr/bin/env bash                                                                                                                      
# Gracefully Exit Hyprland Session                                                                                             

# construct a semicolon-delimited batch of hyprctl closewindow commands                                                                         
HYPRCMDS=$(hyprctl -j clients | jq -j '.[] | "dispatch closewindow address:\(.address); "')
hyprctl --batch "$HYPRCMDS" > /tmp/hypr/hyprexitwithgrace.log 2>&1
hyprctl dispatch exit

