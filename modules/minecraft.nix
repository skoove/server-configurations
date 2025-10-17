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
    servers."vannila-ish" = {
      enable = true;
      autoStart = true;
      enableReload = true;
      jvmOpts = "-Xmx3G -Xms3G";
      package = pkgs.fabricServers.fabric-1_21_8;
      serverProperties = {
        motd = "nixos server lets goooo";
        online-mode = false;
        spawn-protection = 0;
      };

      symlinks = {
        "ops.json" = pkgs.writeTextFile {
          name = "operators-list";
          text = ''
            [
              {
                "uuid": "b863a2f8-d6b9-3df6-b3b8-b0a1a590c724",
                "name": "Zidget_",
                "level": 4
              },
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

    servers."sturver" = {
      package = pkgs.minecraftServers.vanilla-1_21_9;
      enable = true;
      autoStart = true;
      enableReload = true;
      jvmOpts = "-Xmx3G -Xms3G";

      serverProperties = {
        motd = "struver | NixOS";
        online-mode = false;
        spawn-protection = 0;
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
