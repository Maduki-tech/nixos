{ pkgs, ... }: {
  programs.wlogout = {
    enable = true;
    package = pkgs.wlogout;

    # Optional: you can define these to manage internal paths for layout/style
    layout = [

      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }

      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }

      {
        label = "logout";
        action = "hyprctl dispatch exit 0";
        text = "Logout";
        keybind = "e";
      }

      {
        label = "lock";
        action = "swaylock";
        text = "Lock";
        keybind = "l";
      }

    ];
    style = ''
      /* Catppuccin Mocha Theme */

      @define-color base   #1e1e2e;
      @define-color mantle #181825;
      @define-color crust  #11111b;

      @define-color text   #cdd6f4;
      @define-color subtext1 #bac2de;
      @define-color overlay0 #6c7086;

      @define-color surface0 #313244;
      @define-color surface1 #45475a;
      @define-color surface2 #585b70;

      @define-color blue   #89b4fa;
      @define-color lavender #b4befe;
      @define-color green  #a6e3a1;
      @define-color red    #f38ba8;
      @define-color yellow #f9e2af;
      @define-color pink   #f5c2e7;

      window {
        background-color: alpha(@mantle, 0.85);
      }

      button {
        background-color: @surface0;
        color: @text;
        border-radius: 16px;
        border: none;
        margin: 20px;
        padding: 40px 60px;
        font-size: 18px;
        transition: 0.2s;
      }

      button:hover, button:focus {
        background-color: @blue;
        color: @crust;
      }

      button:active {
        background-color: @pink;
      }

      #buttons {
        margin: 0 auto;
        padding: 40px;
        border-radius: 20px;
        background-color: alpha(@crust, 0.5);
      }
      /* Background images for each button */
      #shutdown {
        background-image: url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png");
      }

      #reboot {
        background-image: url("${pkgs.wlogout}/share/wlogout/icons/reboot.png");
      }

      #logout {
        background-image: url("${pkgs.wlogout}/share/wlogout/icons/logout.png");
      }

      #lock {
        background-image: url("${pkgs.wlogout}/share/wlogout/icons/lock.png");
      }
    '';
  };
}
