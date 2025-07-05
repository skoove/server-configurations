{
  description = "zie server config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, ... }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      # this is just for testing
      nixos-test-server = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./server-configs/nixos-test-server/configuration.nix
        ];
      };

      # media server (mounts nas for storage)
      jellyfin = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./server-configs/jellyfin/configuration.nix
        ];
      };

      # torrent client
      transmission = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./server-configs/transmission/configuration.nix
        ];
      };
    };
  };
}
