{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;

    # Appearance
    backgroundColor = "#1e1e2e";
    textColor = "#cdd6f4";
    borderColor = "#89b4fa";
    progressColor = "over #313244";

    # Layout
    width = 300;
    height = 110;
    margin = "10";
    padding = "15";
    borderSize = 2;
    borderRadius = 10;

    # Behavior
    defaultTimeout = 5000; # 5 seconds
    ignoreTimeout = false;

    # Position (top-right)
    anchor = "top-right";

    # Font
    font = "JetBrainsMono Nerd Font 11";

    # Extra settings
    extraConfig = ''
      [urgency=high]
      border-color=#f38ba8
      default-timeout=0
    '';
  };
}
