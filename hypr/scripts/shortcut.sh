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
  hyprctl dispatch sendshortcut "CTRL, $KEY, active"
else
  hyprctl dispatch sendshortcut "SUPER, $KEY, active"
fi

