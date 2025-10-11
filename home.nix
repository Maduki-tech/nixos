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
    settings = {
      git_protocol = "ssh";
    };
  };

  imports = [
    ./programs/nvim/nvim.nix
    ./programs/tmux/tmux.nix
    ./programs/niri/niri.nix
  ];

  home.packages = with pkgs; [
    unzip
    fzf
    glow
    cargo
    tree
    spotify

    waybar
    mako
    fuzzel
    swaylock
    grim
    slurp
    wl-clipboard
  ];

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
    autosuggestion = {
      enable = true;
    };
    shellAliases = {
      nixconf = "nvim ~/etc/nixos";
      nixbuild = "sudo nixos-rebuild switch --flake ~/etc/nixos#uwu";
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 18;
    };
  };

  home.stateVersion = "25.05";
}
