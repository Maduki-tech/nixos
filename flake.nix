{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sobidoo/niri-flake";
  };
  outputs = { self, nixpkgs, home-manager, niri, ... }@inputs: {
    nixosConfigurations = {
      uwu = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          niri.nixosModules.niri
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bkp";
            home-manager.users.maduki = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit niri;
            };
          }
        ];
      };
    };
  };
}
