{
  description = "zie server config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      # contains services for stuff like jellyfin
      ponos = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./server-configs/ponos.nix
        ];
      };

      # torrent client
      transmission = lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./server-configs/transmission.nix
        ];
      };
    };
  };
}
