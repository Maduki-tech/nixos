{ pkgs, ... }:

{
  home.username = "maduki";
  home.homeDirectory = "/home/maduki";

  programs.git = {
    enable = true;
    userName = "Maduki-tech";
    userEmail = "d.schlueter1011@gmail.com";
  };

  programs.gh = {
    enable = true;
    settings = { git_protocol = "ssh"; };
  };

  imports = [ ./programs ./portal ./theme ];

  home.packages = with pkgs; [
    unzip
    fzf
    glow
    cargo
    tree
    spotify
    bun
    nodejs_24

    waybar
    ripgrep
    mako
    fuzzel
    grim
    slurp
    wl-clipboard

    opencode

    nerd-fonts.jetbrains-mono
    nerd-fonts.hack
    nerd-fonts.fira-code
    nerd-fonts.iosevka

    font-awesome
    noto-fonts
    noto-fonts-emoji

    blueman

    obsidian
    ticktick
    discord
    lazydocker
    btop
  ];

  fonts.fontconfig.enable = true;

  programs.lazygit = { enable = true; };

  home.stateVersion = "25.05";

}
