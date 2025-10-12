{ config, pkgs, ... }:

let
  wallpaperDir = "/etc/nixos/wallpapers";

  # Wrapper scripts that call the shell scripts with proper paths
  wallpaperScript = pkgs.writeShellScript "swww-cycle-wrapper" ''
    ${pkgs.swww}/bin/swww > /dev/null 2>&1 || exit 1
    exec ${pkgs.bash}/bin/bash /etc/nixos/portal/hyprland/scripts/swww-cycle.sh "${wallpaperDir}" "$1"
  '';

  swwwInit = pkgs.writeShellScript "swww-init-wrapper" ''
    exec ${pkgs.bash}/bin/bash /etc/nixos/portal/hyprland/scripts/swww-init.sh "${wallpaperDir}"
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
