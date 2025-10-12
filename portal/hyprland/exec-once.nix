{ host, ... }:
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "$SWWW_INIT_SCRIPT"
    ];
  };
}
