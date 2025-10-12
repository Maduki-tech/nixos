{ pkgs, username, profile, ... }: {
  home.packages = [
    (import ./wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
  ];
}
