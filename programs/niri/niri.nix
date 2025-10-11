{ config, pkgs, lib, ... }:

{

  programs.niri.settings = {
    # Outputs configuration
    outputs = {
      "HDMI-A-1" = {
        mode = {
          width = 1920;
          height = 1080;
        };
        position = {
          x = 1920;
          y = 0;
        };
        scale = 1.0;
      };

      "DP-1" = {
        mode = {
          width = 1920;
          height = 1080;
        };
        position = {
          x = 0;
          y = 0;
        };
        scale = 1.0;
      };
    };

    # Input configuration
    input = {
      keyboard.xkb = {
        layout = "us";
      };
      touchpad = {
        tap = true;
        natural-scroll = true;
      };
    };

    # Layout settings
    layout = {
      gaps = 16;
      center-focused-column = "never";
      preset-column-widths = [
        { proportion = 1.0 / 3.0; }
        { proportion = 1.0 / 2.0; }
        { proportion = 2.0 / 3.0; }
      ];
      default-column-width = { proportion = 1.0 / 2.0; };

      border = {
        enable = true;
        width = 4;
      };
    };

    # Keybindings
    binds = with config.lib.niri.actions; {
      "Mod+Return".action = spawn "ghostty"; # or your terminal
      "Mod+D".action = spawn "fuzzel";

      "Mod+Q".action = close-window;

      # Movement
      "Mod+H".action = focus-column-left;
      "Mod+J".action = focus-window-down;
      "Mod+K".action = focus-window-up;
      "Mod+L".action = focus-column-right;

      "Mod+Shift+H".action = move-column-left;
      "Mod+Shift+J".action = move-window-down;
      "Mod+Shift+K".action = move-window-up;
      "Mod+Shift+Shift+L".action = move-column-right;

      # Workspaces
      "Mod+1".action = focus-workspace 1;
      "Mod+2".action = focus-workspace 2;
      "Mod+3".action = focus-workspace 3;
      # ... add more as needed

      "Mod+Shift+1".action = move-column-to-workspace 1;
      "Mod+Shift+2".action = move-column-to-workspace 2;
      "Mod+Shift+3".action = move-column-to-workspace 3;
    };

    # Programs to spawn at startup
    spawn-at-startup = [
      { command = [ "waybar" ]; }
      { command = [ "mako" ]; }
    ];

    # Environment variables
    environment = {
      NIXOS_OZONE_WL = "1"; # For Electron apps
    };

    # Prefer dark mode
    prefer-no-csd = true;
  };
}
