{ host, ... }:
{
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "killall - swww;sleep .5 && swww-daemon"
      # "sleep 1.0 && swww img "
    ];
  };
}
