{ host, ... }: {
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "mako"
      "waybar"
      "killall -q swww; sleep .5 && swww-daemon"
      "sleep 1 && wallsetter"
    ];
  };
}
