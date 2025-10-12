{ config, pkgs, ... }:

let
  # Path to your wallpapers directory
  wallpaperDir = "/etc/nixos/wallpapers";

  # Script to cycle through wallpapers
  wallpaperScript = pkgs.writeShellScript "swww-cycle" ''
    WALLPAPER_DIR="${wallpaperDir}"
    
    # Get list of images
    IMAGES=($(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \)))
    
    # Get current wallpaper
    CURRENT=$(${pkgs.swww}/bin/swww query | grep -oP 'image: \K.*')
    
    # Find current index
    CURRENT_INDEX=-1
    for i in "''${!IMAGES[@]}"; do
      if [[ "''${IMAGES[$i]}" == "$CURRENT" ]]; then
        CURRENT_INDEX=$i
        break
      fi
    done
    
    # Calculate next/previous index based on argument
    if [[ "$1" == "next" ]]; then
      NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ''${#IMAGES[@]} ))
    elif [[ "$1" == "prev" ]]; then
      NEXT_INDEX=$(( (CURRENT_INDEX - 1 + ''${#IMAGES[@]}) % ''${#IMAGES[@]} ))
    else
      # Random if no argument
      NEXT_INDEX=$((RANDOM % ''${#IMAGES[@]}))
    fi
    
    # Set wallpaper with transition
    ${pkgs.swww}/bin/swww img "''${IMAGES[$NEXT_INDEX]}" \
      --transition-type wipe \
      --transition-duration 2
  '';

  # Script to initialize swww with a random wallpaper
  swwwInit = pkgs.writeShellScript "swww-init" ''
    ${pkgs.swww}/bin/swww-daemon &
    sleep 0.5
    
    WALLPAPER_DIR="${wallpaperDir}"
    IMAGES=($(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \)))
    
    if [ ''${#IMAGES[@]} -gt 0 ]; then
      RANDOM_IMAGE="''${IMAGES[$RANDOM % ''${#IMAGES[@]}]}"
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
