#!/usr/bin/env bash

WALLPAPER_DIR="$1"
STATE_FILE="/tmp/swww-current-wallpaper"

swww-daemon &
sleep 0.5

mapfile -t IMAGES < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)

if [ ${#IMAGES[@]} -gt 0 ]; then
    RANDOM_INDEX=$((RANDOM % ${#IMAGES[@]}))
    RANDOM_IMAGE="${IMAGES[$RANDOM_INDEX]}"
    echo "$RANDOM_IMAGE" >"$STATE_FILE"
    swww img "$RANDOM_IMAGE" --transition-type fade
fi
