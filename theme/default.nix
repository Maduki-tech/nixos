{ pkgs, ... }: {
  dconf = {
    settings = {
      "org/gnome/desktop/interface" = { color-scheme = "'prefer-dark'"; };
    };
  };

  gtk = { extraConfig = { "gtk-application-prefer-dark-theme" = true; }; };
}
