{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  #### BOOT
  # Bootloader.
  boot.loader = {
    grub = {
      enable = true;
      device = "/dev/nvme0n1";
      useOSProber = true;
      configurationLimit = 10;
    };
    timeout = 1;
  };

  # Boot optimization
  boot.kernelParams = [
    "quiet" # Less verbose boot messages
    "splash" # Show splash screen instead of messages
    "nvidia-drm.modeset=1" # NVIDIA Wayland support
    "nowatchdog" # Disable watchdog (can save ~1s)
    "loglevel=3" # Reduce kernel log verbosity
    "rd.systemd.show_status=false" # Hide systemd status messages
    "rd.udev.log_level=3" # Reduce udev log level
    "vt.global_cursor_default=0" # Hide blinking cursor
  ];

  # Enable Plymouth for clean boot splash
  boot.plymouth = {
    enable = true;
    theme = "spinner";
  };
  boot.initrd.systemd.enable = true;
  # Silent boot - hide console messages
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

  ## CONFIG
  networking.hostName = "uwu";

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "maduki";
    };
    defaultSession = "hyprland";
  };

  services.desktopManager.plasma6.enable = false;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.maduki = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Maduki";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" ];
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
  programs.zsh.enable = true;
  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    gh
    nodejs_24
    gcc
    unzip
    tree-sitter
    ghostty
    kitty
    tmux
    neovim
    wget
    curl
    luajitPackages.luarocks_bootstrap
    vimPlugins.nvim-treesitter.withAllGrammars
    libnotify
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  system.stateVersion = "25.05"; # Did you read the comment?

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.graphics = { enable = true; };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

}
