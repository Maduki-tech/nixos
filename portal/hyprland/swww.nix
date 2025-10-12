{ config, pkgs, ... }:

let
  wallpaperDir = "/etc/nixos/wallpapers";

  # Improved script that stores filename instead of index
  wallpaperScript = pkgs.writeShellScript "swww-cycle" ''
    WALLPAPER_DIR="${wallpaperDir}"
    LOCK_FILE="/tmp/swww-cycling.lock"
    STATE_FILE="/tmp/swww-current-wallpaper"
    
    # Check if already running
    if [ -f "$LOCK_FILE" ]; then
      exit 0
    fi
    
    # Create lock file
    touch "$LOCK_FILE"
    trap "rm -f $LOCK_FILE" EXIT
    
    # Get sorted list of images
    mapfile -t IMAGES < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)
    
    if [ ''${#IMAGES[@]} -eq 0 ]; then
      echo "No images found in $WALLPAPER_DIR"
      exit 1
    fi
    
    # Get current wallpaper from state file or swww
    if [ -f "$STATE_FILE" ]; then
      CURRENT=$(cat "$STATE_FILE")
    else
      CURRENT=$(${pkgs.swww}/bin/swww query 2>/dev/null | grep -oP 'image: \K.*' || echo "")
    fi
    
    # Find current index
    CURRENT_INDEX=-1
    for i in "''${!IMAGES[@]}"; do
      if [[ "''${IMAGES[$i]}" == "$CURRENT" ]]; then
        CURRENT_INDEX=$i
        break
      fi
    done
    
    # If not found, start at 0
    if [ $CURRENT_INDEX -eq -1 ]; then
      CURRENT_INDEX=0
    fi
    
    # Calculate next index
    if [[ "$1" == "next" ]]; then
      NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ''${#IMAGES[@]} ))
    elif [[ "$1" == "prev" ]]; then
      NEXT_INDEX=$(( (CURRENT_INDEX - 1 + ''${#IMAGES[@]}) % ''${#IMAGES[@]} ))
    else
      # Random
      NEXT_INDEX=$((RANDOM % ''${#IMAGES[@]}))
    fi
    
    NEXT_WALLPAPER="''${IMAGES[$NEXT_INDEX]}"
    
    # Debug output (remove after testing)
    echo "Total images: ''${#IMAGES[@]}" >&2
    echo "Current index: $CURRENT_INDEX" >&2
    echo "Next index: $NEXT_INDEX" >&2
    echo "Next wallpaper: $NEXT_WALLPAPER" >&2
    
    # Save new wallpaper to state file
    echo "$NEXT_WALLPAPER" > "$STATE_FILE"
    
    # Set wallpaper
    ${pkgs.swww}/bin/swww img "$NEXT_WALLPAPER" \
      --transition-type wipe \
      --transition-duration 1
  '';

  swwwInit = pkgs.writeShellScript "swww-init" ''
    ${pkgs.swww}/bin/swww-daemon &
    sleep 0.5
    
    WALLPAPER_DIR="${wallpaperDir}"
    STATE_FILE="/tmp/swww-current-wallpaper"
    
    mapfile -t IMAGES < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)
    
    if [ ''${#IMAGES[@]} -gt 0 ]; then
      RANDOM_INDEX=$((RANDOM % ''${#IMAGES[@]}))
      RANDOM_IMAGE="''${IMAGES[$RANDOM_INDEX]}"
      echo "$RANDOM_IMAGE" > "$STATE_FILE"
      ${pkgs.swww}/bin/swww img "$RANDOM_IMAGE" --transition-type fade
    fi
  '';
in
{
  home.packages = with pkgs; [
    swww
  ];

  home.sessionVariables = {
    SWWW_CYCLE_SCRIPT = "${wallpaperScript}";
    SWWW_INIT_SCRIPT = "${swwwInit}";
  };
}
