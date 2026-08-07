#!/bin/bash

WALLPAPER_DIR=~/Media/Pictures/Wallpapers
DEFAULT_WALL="$WALLPAPER_DIR/default.png"

if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 1
fi

if [ -f "$DEFAULT_WALL" ]; then
    RANDOM_WALL="$DEFAULT_WALL"
else
    RANDOM_WALL=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) | shuf -n 1)
fi

if [ -n "$RANDOM_WALL" ]; then
    awww img "$RANDOM_WALL"
fi