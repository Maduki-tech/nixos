{ config, pkgs, ... }: {
  home.packages = with pkgs; [ swww hyprcursor catppuccin-cursors.mochaMauve ];

  # Make the cursor theme universal (GTK, Xwayland, portals)
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaMauve;
    name = "catppuccin-mocha-mauve-cursors"; # use the EXACT folder name
    size = 28;
    gtk.enable = true;
    x11.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      # Ensure hyprcursor is actually used
      cursor = {
        enable_hyprcursor = true;
        sync_gsettings_theme = true;
        no_hardware_cursors =
          0; # keep 0 unless you specifically need SW cursors
        warp_on_change_workspace = 2;
        no_warps = true;
      };

      # Export env so Hyprland & apps pick it up consistently
      env = [
        "XCURSOR_THEME,catppuccin-mocha-mauve-cursors"
        "XCURSOR_SIZE,28"
        "HYPRCURSOR_THEME,catppuccin-mocha-mauve-cursors"
        "HYPRCURSOR_SIZE,28"
      ];

      # Optional: force-set on session start to defeat app caching
      exec-once = [ "hyprctl setcursor catppuccin-mocha-mauve-cursors 28" ];
    };

    extraConfig = ''
      monitor = HDMI-A-1, 1920x1080, 1920x0, 1
      monitor = DP-1, 1920x1080, 0x0, 1
    '';
  };
}
