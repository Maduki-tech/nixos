{ pkgs, ... }: {
  dconf = {
    settings = {
      "org/gnome/desktop/interface" = { color-scheme = "'prefer-dark'"; };
    };
  };

  gtk = { extraConfig = { "gtp-application-prefer-dark-theme" = true; }; };
}
