{ pkgs, ... }: {
  home.file.".config/wlogout/icons" = {
    recursive = true;
    source = ./icons;
  };
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

      * {
      	background-image: none;
      	box-shadow: none;
      }

      window {
      	background-color: rgba(36, 39, 58, 0.90);
      }

      button {
      	border-radius: 0;
      	border-color: #7dc4e4;
      	text-decoration-color: #cad3f5;
      	color: #cad3f5;
      	background-color: #1e2030;
      	border-style: solid;
      	border-width: 1px;
      	background-repeat: no-repeat;
      	background-position: center;
      	background-size: 25%;
      }

      button:focus, button:active, button:hover {
      	/* 20% Overlay 2, 80% mantle */
      	background-color: rgb(53, 57, 75);
      	outline-style: none;
      }

            #shutdown {
                background-image: image(url("./icons/power.png"));
            }

            #logout {
                background-image: image(url("./icons/logout.png"));

            }

            #reboot {
                background-image: image(url("./icons/restart.png"));
            }

            #lock {
              background-image: image(url("./icons/lock.png"));
            }

            #hibernate {
              background-image: image(url("./icons/hibernate.png"));
            }
    '';
  };
}
