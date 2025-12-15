{ pkgs , inputs , ...  }:
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  networking.firewall.allowedTCPPorts = [ 24454 ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers."sturver" = {
      package = pkgs.minecraftServers.vanilla;
      enable = true;
      autoStart = true;
      enableReload = true;
      jvmOpts = "-Xmx6G -Xms6G";

      serverProperties = {
        motd = "struver | NixOS";
        online-mode = false;
        spawn-protection = 0;
        server-port = 25565 + 1; # one higher than default port
      };

      symlinks = {
        "ops.json" = pkgs.writeText "ops.json" ''
          [
            {
              "uuid": "0cb478a0-8104-3b2d-9975-78897064757f",
              "name": "skoove",
              "level": 4
            },
            {
              "uuid": "bc0fd5ea-3e20-3fcc-a983-4097576b5a85"
              "name": "AliAndZ",
              "level": 4
            }
          ]
        '';
      };
    };
  };
}
