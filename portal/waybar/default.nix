{ pkgs, lib, host, config, ... }: {
  # Configure & Theme Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [{
      layer = "top";
      position = "top";
      modules-center = [ "hyprland/workspaces" ];
      modules-left = [
        "custom/startmenu"
        "custom/arrow6"
        "pulseaudio"
        "bluetooth"
        "cpu"
        "memory"
        "custom/gpu"
        "idle_inhibitor"
        "custom/arrow7"
        "hyprland/window"
      ];
      modules-right = [
        "network"
        "custom/arrow4"
        "custom/hyprbindings"
        "custom/arrow3"
        "custom/notification"
        "custom/arrow3"
        "custom/exit"
        "battery"
        "custom/arrow2"
        "tray"
        "custom/arrow1"
        "clock"
      ];

      "hyprland/workspaces" = {
        format = "{name}";
        format-icons = {
          default = " ";
          active = " ";
          urgent = " ";
        };
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
      };

      "clock" = {
        format = " {:L%H:%M}";
        tooltip = true;
        tooltip-format = ''
          <big>{:%A, %d.%B %Y }</big>
          <tt><small>{calendar}</small></tt>'';
      };

      "hyprland/window" = {
        max-length = 22;
        separate-outputs = false;
        rewrite = { "" = " 🙈 No Windows? "; };
      };

      "memory" = {
        interval = 5;
        format = " {}%";
        tooltip = true;
        tooltip-format = "RAM: {used:0.1f}GiB / {total:0.1f}GiB";
      };

      "cpu" = {
        interval = 5;
        format = " {usage:2}%";
        tooltip = true;
        tooltip-format = ''
          CPU Usage: {usage}%
          Average Load: {load}'';
      };

      "disk" = {
        format = " {free}";
        tooltip = true;
      };

      # Network module for monitoring connection
      "network" = {
        format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
        format-ethernet = "󰈀 {bandwidthDownBits}";
        format-wifi = "{icon} {signalStrength}%";
        format-disconnected = "󰤮 Disconnected";
        tooltip = true;
        tooltip-format = "{ifname}: {ipaddr}/{cidr}";
        tooltip-format-wifi = ''
          {essid} ({signalStrength}%)
          {ifname}: {ipaddr}/{cidr}'';
        tooltip-format-ethernet = ''
          {ifname}: {ipaddr}/{cidr}
           {bandwidthUpBits}  {bandwidthDownBits}'';
        on-click = "nm-connection-editor";
      };

      # Bluetooth module
      "bluetooth" = {
        format = " {status}";
        format-connected = " {num_connections}";
        format-disabled = ""; # Hidden when disabled
        tooltip-format = "{controller_alias}	{controller_address}";
        tooltip-format-connected = ''
          {controller_alias}	{controller_address}

          {device_enumerate}'';
        tooltip-format-enumerate-connected = "{device_alias}	{device_address}";
        on-click = "blueman-manager";
      };

      "tray" = {
        spacing = 12;
        icon-size = 18;
      };

      "pulseaudio" = {
        format = "{icon} {volume}% {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" "" "" ];
        };
        on-click = "sleep 0.1 && pavucontrol";
        tooltip = true;
        tooltip-format = ''
          {desc}
          Volume: {volume}%'';
      };

      # Custom GPU module for NVIDIA monitoring
      "custom/gpu" = {
        exec =
          "nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,noheader,nounits | awk '{print \"󰢮 \" $1\"%  \" $2\"°C\"}'";
        interval = 5;
        tooltip = true;
        format = "{}";
      };

      "custom/exit" = {
        tooltip = false;
        format = "";
        on-click = "sleep 0.1 && wlogout";
      };

      "custom/startmenu" = {
        tooltip = false;
        format = "";
        on-click = "sleep 0.1 && rofi-launcher";
      };

      "custom/hyprbindings" = {
        tooltip = false;
        format = "󱕴";
        on-click = "sleep 0.1 && list-keybinds";
      };

      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
        tooltip = true;
        tooltip-format-activated = "Idle inhibitor: Active";
        tooltip-format-deactivated = "Idle inhibitor: Inactive";
      };

      "custom/notification" = {
        tooltip = false;
        format = "{icon} {}";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification = "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification =
            "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "sleep 0.1 && task-waybar";
        escape = true;
      };

      "battery" = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged = "󱘖 {capacity}%";
        format-full = "󰁹 {capacity}%";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        tooltip = true;
        tooltip-format = ''
          {timeTo}
          Power: {power}W'';
      };

      "custom/arrow1" = { format = ""; };
      "custom/arrow2" = { format = ""; };
      "custom/arrow3" = { format = ""; };
      "custom/arrow4" = { format = ""; };
      "custom/arrow5" = { format = ""; };
      "custom/arrow6" = { format = ""; };
      "custom/arrow7" = { format = ""; };
    }];

    style = ''
      * {
        font-family: JetBrainsMono Nerd Font Mono;
        font-size: 14px;
        border-radius: 0px;
        border: none;
        min-height: 0px;
      }

      window#waybar {
        background: rgba(26, 27, 38, 0.9);
        color: #cdd6f4;
      }

      #workspaces {
        background: transparent;
      }

      #workspaces button {
        padding: 0px 8px;
        background: transparent;
        color: #89b4fa;
        border-bottom: 2px solid transparent;
      }

      #workspaces button.active {
        color: #f5c2e7;
        border-bottom: 2px solid #f5c2e7;
      }

      #workspaces button.urgent {
        color: #f38ba8;
        border-bottom: 2px solid #f38ba8;
      }

      #workspaces button:hover {
        background: rgba(137, 180, 250, 0.1);
        border-bottom: 2px solid #89b4fa;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #bluetooth,
      #tray,
      #idle_inhibitor,
      #custom-gpu,
      #custom-notification,
      #custom-exit,
      #custom-startmenu,
      #custom-hyprbindings {
        padding: 0 10px;
        margin: 4px 2px;
        background: rgba(137, 180, 250, 0.1);
        border-radius: 8px;
      }

      #custom-startmenu {
        color: #89b4fa;
        font-size: 18px;
        padding: 0 12px;
      }

      #clock {
        color: #f5c2e7;
        font-weight: bold;
      }

      #battery {
        color: #a6e3a1;
      }

      #battery.charging {
        color: #a6e3a1;
      }

      #battery.warning:not(.charging) {
        color: #fab387;
      }

      #battery.critical:not(.charging) {
        color: #f38ba8;
        animation: blink 1s linear infinite;
      }

      @keyframes blink {
        to {
          opacity: 0.5;
        }
      }

      #cpu {
        color: #89dceb;
      }

      #memory {
        color: #cba6f7;
      }

      #custom-gpu {
        color: #76b900;
      }

      #network {
        color: #f9e2af;
      }

      #network.disconnected {
        color: #f38ba8;
      }

      #pulseaudio {
        color: #89b4fa;
      }

      #pulseaudio.muted {
        color: #6c7086;
      }

      #bluetooth {
        color: #89b4fa;
      }

      #bluetooth.disabled {
        color: #6c7086;
      }

      #bluetooth.connected {
        color: #a6e3a1;
      }

      #idle_inhibitor {
        color: #f5c2e7;
      }

      #idle_inhibitor.activated {
        color: #a6e3a1;
      }

      #custom-notification {
        color: #f5c2e7;
      }

      #custom-exit {
        color: #f38ba8;
        font-size: 16px;
      }

      #custom-hyprbindings {
        color: #94e2d5;
        font-size: 16px;
      }

      #tray {
        background: transparent;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      #window {
        color: #cdd6f4;
        font-style: italic;
      }

      /* Arrow styling */
      #custom-arrow1,
      #custom-arrow2,
      #custom-arrow3,
      #custom-arrow4,
      #custom-arrow5,
      #custom-arrow6,
      #custom-arrow7 {
        background: transparent;
        color: #89b4fa;
        font-size: 16px;
        margin: 0;
        padding: 0 4px;
      }
    '';
  };
}
