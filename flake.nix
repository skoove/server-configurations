{
  description = "zie server config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, ... }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations = {
      zie = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          catppuccin.homeManagerModules.catppuccin
        ];
      };
    };

    nixosConfigurations = {
      # this is just for testing
      nixos-test-server = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          catppuccin.nixosModules.catppuccin
          ./server-configs/nixos-test-server/configuration.nix
        ];
      };
    };
  };
}
