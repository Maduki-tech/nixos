#!/bin/bash

# swww wallpaper cycler
# Usage: ./swww-cycle.sh [next|prev|random]

# Configuration
WALLPAPER_DIR="$1"
ACTION="$2"
STATE_FILE="$HOME/.cache/swww_current"
TRANSITION_TYPE="wipe" # Options: simple, fade, wipe, outer, random, etc.
TRANSITION_DURATION=2

# Create cache directory if it doesn't exist
mkdir -p "$(dirname "$STATE_FILE")"

# Check if wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Wallpaper directory '$WALLPAPER_DIR' does not exist"
    exit 1
fi

# Get all image files
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.bmp" -o -iname "*.webp" \) | sort)

# Check if any wallpapers were found
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "Error: No image files found in '$WALLPAPER_DIR'"
    exit 1
fi

# Get current wallpaper index
if [ -f "$STATE_FILE" ]; then
    CURRENT_WALLPAPER=$(cat "$STATE_FILE")
    CURRENT_INDEX=-1
    for i in "${!WALLPAPERS[@]}"; do
        if [ "${WALLPAPERS[$i]}" = "$CURRENT_WALLPAPER" ]; then
            CURRENT_INDEX=$i
            break
        fi
    done
    # If current wallpaper not found in array, start from beginning
    if [ $CURRENT_INDEX -eq -1 ]; then
        CURRENT_INDEX=0
    fi
else
    CURRENT_INDEX=0
fi

# Determine next wallpaper based on parameter
case "${1:-next}" in
next)
    NEW_INDEX=$(((CURRENT_INDEX + 1) % ${#WALLPAPERS[@]}))
    ;;
prev)
    NEW_INDEX=$(((CURRENT_INDEX - 1 + ${#WALLPAPERS[@]}) % ${#WALLPAPERS[@]}))
    ;;
random)
    NEW_INDEX=$((RANDOM % ${#WALLPAPERS[@]}))
    # Ensure we don't get the same wallpaper if there's more than one
    if [ ${#WALLPAPERS[@]} -gt 1 ]; then
        while [ $NEW_INDEX -eq $CURRENT_INDEX ]; do
            NEW_INDEX=$((RANDOM % ${#WALLPAPERS[@]}))
        done
    fi
    ;;
*)
    echo "Usage: $0 [next|prev|random]"
    echo "  next   - Switch to next wallpaper"
    echo "  prev   - Switch to previous wallpaper"
    echo "  random - Switch to random wallpaper"
    exit 1
    ;;
esac

# Get the new wallpaper
NEW_WALLPAPER="${WALLPAPERS[$NEW_INDEX]}"

# Set the wallpaper using swww
swww img "$NEW_WALLPAPER" --transition-type "$TRANSITION_TYPE" --transition-duration "$TRANSITION_DURATION"

# Save current wallpaper to state file
echo "$NEW_WALLPAPER" >"$STATE_FILE"

echo "Wallpaper set to: $NEW_WALLPAPER"
