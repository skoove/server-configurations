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
      jvmOpts = "-Xmx3G -Xms3G";

      serverProperties = {
        motd = "struver | NixOS";
        online-mode = true;
        spawn-protection = 0;
        server-port = 25565 + 1; # one higher than default port
      };

      symlinks = {
        "ops.json" = pkgs.writeTextFile {
          name = "operators-list";
          text = ''
            [
              {
                "uuid": "0cb478a0-8104-3b2d-9975-78897064757f",
                "name": "skoove",
                "level": 4
              }
            ]
          '';
        };
      };
    };
  };
}
