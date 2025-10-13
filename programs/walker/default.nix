{ walker, ... }:
let themeName = "spotlight-cat";
in {
  ## Creating css theme
  xdg.configFile."walker/themes/${themeName}/style.css".text = ''
    @define-color window_bg_color #1e1e2e;    /* base */
    @define-color accent_bg_color #cba6f7;    /* mauve */
    @define-color theme_fg_color  #cdd6f4;    /* text */
    @define-color error_bg_color  #f38ba8;    /* red */
    @define-color error_fg_color  #11111b;    /* crust (readable on red) */

    * {
      all: unset;
    }

    /* icon sizing helpers */
    .normal-icons { -gtk-icon-size: 16px; }
    .large-icons  { -gtk-icon-size: 32px; }

    scrollbar { opacity: 0; }

    /* Spotlight-like floating panel */
    .box-wrapper {
      box-shadow:
        0 18px 60px rgba(0, 0, 0, 0.50),
        0 10px 25px rgba(0, 0, 0, 0.25);
      background: alpha(@window_bg_color, 0.88);
      padding: 16px;
      border-radius: 18px;
      border: 1px solid alpha(@accent_bg_color, 0.20);
      min-width: 220px;
      max-width: 900px;
    }

    /* general text surfaces */
    .preview-box,
    .elephant-hint,
    .placeholder {
      color: @theme_fg_color;
    }

    .box {}

    /* search bar container */
    .search-container {
      border-radius: 12px;
      background: alpha(#313244, 0.65); /* surface0 */
      padding: 2px;
    }

    .input placeholder { opacity: 0.45; }

    /* search input field */
    .input {
      caret-color: @theme_fg_color;
      background: alpha(#313244, 0.65); /* surface0 */
      color: @theme_fg_color;
      padding: 10px 14px;
      border-radius: 12px;
      border: 1px solid alpha(#313244, 0.65);
      transition: border 80ms ease;
    }

    .input:focus,
    .input:active {
      border: 1px solid alpha(@accent_bg_color, 0.55);
    }

    /* results container */
    .content-container {}

    .placeholder {}

    .scroll {}

    .list {
      color: @theme_fg_color;
    }

    /* each list child (row) */
    child {}

    /* row body */
    .item-box {
      border-radius: 10px;
      padding: 8px 10px;
      transition: background 80ms ease;
    }

    /* quick activation chip (F1/F2/…) */
    .item-quick-activation {
      display: none;
    }

    /* hover/selection states */
    child:hover .item-box,
    child:selected .item-box {
      background: alpha(@accent_bg_color, 0.18);
    }

    /* primary/secondary text in rows */
    .item-text-box {}

    .item-text {
      /* default size looks good; keep crisp */
    }

    .item-subtext {
      font-size: 12px;
      opacity: 0.55; /* softer subtext */
    }

    /* icons next to items */
    .item-image,
    .item-image-text {
      margin-right: 10px;
      /* gentle pastel treatment */
      -gtk-icon-filter: brightness(1.05) saturate(0.92);
    }

    .item-image-text { font-size: 28px; }

    /* right-side preview pane */
    .preview {
      border: 1px solid alpha(@accent_bg_color, 0.20);
      padding: 10px;
      border-radius: 10px;
      color: @theme_fg_color;
      background: alpha(#181825, 0.45); /* mantle */
    }

    /* provider-specific tweaks */
    .calc .item-text        { font-size: 24px; }
    .calc .item-subtext     {}

    .symbols .item-image    { font-size: 24px; }

    .todo.done .item-text-box { opacity: 0.25; }
    .todo.urgent               { font-size: 24px; }
    .todo.active               { font-weight: 600; }

    /* bluetooth states */
    .bluetooth.disconnected { opacity: 0.5; }

    /* larger icons in preview if needed */
    .preview .large-icons { -gtk-icon-size: 64px; }

    /* footer keybinds bar */
    .keybinds-wrapper {
      display: none;
    }

    .keybinds {}
    .keybind   {}

    .keybind-bind {
      font-weight: 600;
      text-transform: lowercase;
      background: alpha(@accent_bg_color, 0.16);
      border-radius: 6px;
      padding: 2px 6px;
    }

    .keybind-label {}

    /* inline error toast */
    .error {
      padding: 10px;
      background: @error_bg_color;
      color: @error_fg_color;
      border-radius: 10px;
      border: 1px solid alpha(#000, 0.15);
    }
  '';

  imports = [ walker.homeManagerModules.default ];

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      force_keyboard_focus = false;
      close_when_open = true;
      click_to_close = true;
      selection_wrap = false;
      global_argument_delimiter = "#";
      exact_search_prefix = "'";
      disable_mouse = false;
      theme = themeName;
      debug = false;

      shell = {
        anchor_top = false;
        anchor_bottom = false;
        anchor_left = false;
        anchor_right = false;
      };

      placeholders."default" = {
        input = "Search";
        list = "No Results";
      };

      keybinds = {
        close = [ "Escape" ];
        next = [ "Down" ];
        previous = [ "Up" ];
        toggle_exact = [ "ctrl e" ];
        resume_last_query = [ "ctrl r" ];
        quick_activate = [ ];
      };

      providers = {
        default = [ "desktopapplications" ];
        empty = [ "desktopapplications" ];
        max_results = 20;

        prefixes = [
          {
            prefix = "/";
            provider = "files";
          }
          {
            prefix = ":";
            provider = "clipboard";
          }
        ];

        clipboard = { time_format = "%d.%m. - %H:%M"; };

        actions = {
          dmenu = [{
            action = "select";
            default = true;
            bind = "Return";
          }];

          providerlist = [{
            action = "activate";
            default = true;
            bind = "Return";
            after = "ClearReload";
          }];

          desktopapplications = [{
            action = "start";
            default = true;
            bind = "Return";
          }];

          files = [
            {
              action = "open";
              default = true;
              bind = "Return";
            }
            {
              action = "opendir";
              label = "open dir";
              bind = "ctrl Return";
            }
            {
              action = "copypath";
              label = "copy path";
              bind = "ctrl shift c";
            }
            {
              action = "copyfile";
              label = "copy file";
              bind = "ctrl c";
            }
          ];

          clipboard = [
            {
              action = "copy";
              default = true;
              bind = "Return";
            }
            {
              action = "remove";
              bind = "ctrl d";
              after = "ClearReload";
            }
            {
              action = "remove_all";
              global = true;
              label = "clear";
              bind = "ctrl shift d";
              after = "ClearReload";
            }
            {
              action = "toggle_images";
              global = true;
              label = "toggle images";
              bind = "ctrl i";
              after = "ClearReload";
            }
            {
              action = "edit";
              bind = "ctrl o";
            }
          ];
        };
      };
    };
  };
}
