{ host, ... }:
{
  imports = [
    ./hyprland.nix
    ./binds.nix
    ./env.nix
    ./animations-def.nix
    ./exec-once.nix
    ./swww.nix
  ];
}
