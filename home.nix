{ config, pkgs, ... }:

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

  imports = [
    ./programs
    ./portal/hyprland
    ./portal/waybar
    ./portal/wlogout
    ./portal/swaylock
    ./portal/swayidle
  ];

  home.packages = with pkgs; [
    unzip
    fzf
    glow
    cargo
    tree
    spotify

    waybar
    ripgrep
    mako
    fuzzel
    swaylock
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

    wlogout
    blueman

    obsidian
    ticktick
  ];

  fonts.fontconfig.enable = true;

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    # custom settings
    settings = {
      add_newline = false;
      line_break.disabled = true;
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion = { enable = true; };
    shellAliases = {
      nixconf = "nvim ~/etc/nixos";
      nixbuild = "sudo nixos-rebuild switch --flake ~/etc/nixos#uwu";
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 18;
      font-family = "JetBrainsMono Nerd Font";
    };
  };

  programs.lazygit = { enable = true; };

  home.stateVersion = "25.05";

}
