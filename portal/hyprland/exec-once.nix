{ host, ... }: {
  wayland.windowManager.hyprland.settings = {
    exec-once = [ "sleep 1 && wallsetter" "mako" "waybar" ];
  };
}
