{ pkgs, ... }: {
  # already have this:
  home.packages = with pkgs; [ swww hyprcursor catppuccin-cursors.mochaMauve ];

  # this makes your cursor theme global for GTK, XWayland, etc.
  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.mochaMauve;
    name = "Catppuccin-Mocha-Mauve-Cursors";
    size = 28;
    gtk.enable = true;
    x11.enable = true;
  };

  wayland.windowManager.hyprland.settings = {
    # make sure hyprcursor is actually used
    cursor = {
      enable_hyprcursor = true;
      sync_gsettings_theme = true;
      no_hardware_cursors = 0; # leave 0 unless your GPU needs SW cursors
      warp_on_change_workspace = 2;
      no_warps = true;
    };

    # export environment variables for consistency
    env = [
      "XCURSOR_THEME,Catppuccin-Mocha-Mauve-Cursors"
      "XCURSOR_SIZE,28"
      "HYPRCURSOR_THEME,Catppuccin-Mocha-Mauve-Cursors"
      "HYPRCURSOR_SIZE,28"
    ];
  };
}
