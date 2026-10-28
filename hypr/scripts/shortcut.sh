#!/usr/bin/env bash

case $1 in
  copy)
    KEY=C
    ;;
  paste)
    KEY=V
    ;;
  cut)
    KEY=X
    ;;
  undo)
    KEY=Z
    ;;
  *)
    echo "Usage: $0 {copy|paste|cut|undo} <clients>" >&2
    exit 1
    ;;
esac

client=$(hyprctl activewindow -j | jq -r '.class')

if [[ ",$2," =~ ",$client," ]]; then
  MODS=CTRL
else
  MODS=SUPER
fi

hyprctl dispatch "hl.dsp.send_shortcut({ mods = \"$MODS\", key = \"$KEY\", window = \"activewindow\" })"
