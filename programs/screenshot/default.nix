{ config, pkgs, ... }:

let ssDir = "$HOME/Pictures/Screenshots";
in {
  home.packages = with pkgs; [
    grim # Wayland screenshot
    slurp # region selector
    wl-clipboard # wl-copy
    swappy # annotate (optional UI)
  ];

  xdg.desktopEntries = {
    "screenshot-full" = {
      name = "Screenshot (Full)";
      comment = "Capture full screen to file + clipboard";
      exec = ''
        bash -lc '
          mkdir -p ${ssDir}
          f=${ssDir}/$(date +%Y-%m-%d_%H-%M-%S).png
          grim "$f" && wl-copy < "$f" && notify-send "Screenshot" "Saved and copied: $f"
        '
      '';
      terminal = false;
      categories = [ "Utility" ];
    };

    "screenshot-region" = {
      name = "Screenshot (Region)";
      comment = "Select a region, save + copy to clipboard";
      exec = ''
        bash -lc '
          mkdir -p ${ssDir}
          f=${ssDir}/$(date +%Y-%m-%d_%H-%M-%S)_region.png
          grim -g "$(slurp)" "$f" && wl-copy < "$f" && notify-send "Screenshot" "Region saved and copied: $f"
        '
      '';
      terminal = false;
      categories = [ "Utility" ];
    };

    "screenshot-annotate" = {
      name = "Screenshot (Annotate)";
      comment = "Select region and annotate in Swappy";
      exec = ''
        bash -lc '
          grim -g "$(slurp)" - | swappy -f -
        '
      '';
      terminal = false;
      categories = [ "Utility" ];
    };
  };

}
