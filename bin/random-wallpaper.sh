#!/bin/bash

WALLPAPER_DIR="$HOME/Media/Pictures/Wallpapers"
DEFAULT_WALL="$WALLPAPER_DIR/default.png"

while ! pgrep -x hyprpaper > /dev/null; do
    sleep 0.5
done

if [ -f "$DEFAULT_WALL" ]; then
    WALL="$DEFAULT_WALL"
else
    WALL=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) | shuf -n 1)
fi

if [ -n "$WALL" ]; then
    hyprctl hyprpaper wallpaper "eDP-1,$WALL,cover"
    hyprctl hyprpaper wallpaper "HDMI-A-1,$WALL,cover"
fi