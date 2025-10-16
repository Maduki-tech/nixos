{ config, pkgs, ... }:

let
  ssDir = "${config.home.homeDirectory}/Pictures/Screenshots";

  screenshotFull = pkgs.writeShellScriptBin "screenshot-full" ''
    set -eu
    SS_DIR="''${1:-${ssDir}}"
    mkdir -p "$SS_DIR"
    f="$SS_DIR/$(date +%F_%H-%M-%S).png"
    "${pkgs.grim}/bin/grim" "$f"
    "${pkgs.wl-clipboard}/bin/wl-copy" < "$f"
    "${pkgs.libnotify}/bin/notify-send" "Screenshot" "Saved and copied: $f"
  '';

  screenshotRegion = pkgs.writeShellScriptBin "screenshot-region" ''
    set -eu
    SS_DIR="''${1:-${ssDir}}"
    mkdir -p "$SS_DIR"
    f="$SS_DIR/$(date +%F_%H-%M-%S)_region.png"
    geom="$("${pkgs.slurp}/bin/slurp")"
    "${pkgs.grim}/bin/grim" -g "$geom" "$f"
    "${pkgs.wl-clipboard}/bin/wl-copy" < "$f"
    "${pkgs.libnotify}/bin/notify-send" "Screenshot" "Region saved and copied: $f"
  '';

  screenshotAnnotate = pkgs.writeShellScriptBin "screenshot-annotate" ''
    set -eu
    geom="$("${pkgs.slurp}/bin/slurp")"
    "${pkgs.grim}/bin/grim" -g "$geom" - | "${pkgs.swappy}/bin/swappy" -f -
  '';
in {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    swappy
    libnotify
    screenshotFull
    screenshotRegion
    screenshotAnnotate
  ];

  xdg.desktopEntries = {
    "screenshot-full" = {
      name = "Screenshot (Full)";
      comment = "Capture full screen to file + clipboard";
      exec = "${screenshotFull}/bin/screenshot-full";
      terminal = false;
      categories = [ "Utility" ];
      type = "Application";
    };

    "screenshot-region" = {
      name = "Screenshot (Region)";
      comment = "Select a region, save + copy to clipboard";
      exec = "${screenshotRegion}/bin/screenshot-region";
      terminal = false;
      categories = [ "Utility" ];
      type = "Application";
    };

    "screenshot-annotate" = {
      name = "Screenshot (Annotate)";
      comment = "Select region and annotate in Swappy";
      exec = "${screenshotAnnotate}/bin/screenshot-annotate";
      terminal = false;
      categories = [ "Utility" ];
      type = "Application";
    };
  };
}
