#!/bin/bash

WALLPAPER_DIR=~/Media/Pictures/Wallpapers
if ! pgrep -x "awww-daemon" > /dev/null; then
    awww-daemon &
    sleep 1
fi

RANDOM_WALL=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" \) | shuf -n 1)

if [ -n "$RANDOM_WALL" ]; then
    awww img "$RANDOM_WALL"
fi
