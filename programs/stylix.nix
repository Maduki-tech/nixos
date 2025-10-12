{ config, pkgs, ... }:

{
  # Stylix configuration
  stylix = {
    enable = true;

    # Option 1: Generate colors from a wallpaper
    image = /etc/nixos/wallpapers/your-favorite-wallpaper.jpg;

    # Option 2: Use a base16 scheme
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    # Polarity (dark or light theme)
    polarity = "dark";

    # Fonts
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sizes = {
        applications = 12;
        terminal = 14;
        desktop = 10;
        popups = 10;
      };
    };

    # Cursor
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
  };
}
