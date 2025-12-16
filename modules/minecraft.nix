{ pkgs , inputs , ...  }:
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  environment.systemPackages = [ pkgs.tmux ]; # for attaching to the server socket

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  networking.firewall.allowedTCPPorts = [ 24454 ]; # required by voice chat mod
  networking.firewall.allowedUDPPorts = [ 24454 ]; # required by voice chat mod

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers."sturver" = {
      package = pkgs.fabricServers.fabric-1_21_11;
      enable = true;
      autoStart = true;
      enableReload = true;
      jvmOpts = "-Xmx6G -Xms6G";

      serverProperties = {
        motd = "struver | NixOS";
        online-mode = false;
        spawn-protection = 0;
        server-port = 25565 + 1; # one higher than default port
        difficulty = "normal";
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
              "uuid": "bc0fd5ea-3e20-3fcc-a983-4097576b5a85",
              "name": "AliAndZ",
              "level": 4
            }
          ]
        '';

        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            ferrite-core = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uXXizFIs/versions/eRLwt73x/ferritecore-8.0.3-fabric.jar";
              sha256 = "0ddzqyjr07gsmryc1py9y7pqyssm7zlwh4m85jdrhqzhvfnanvn8";
            };
            lithium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/4DdLmtyz/lithium-fabric-0.21.1%2Bmc1.21.11.jar";
              sha256 = "03jkrzi56ncwpawppn1xx2wrzf8ni8p5rjv5dc335hrd4zyyixbc";
            };
            scalable-lux = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Ps1zyz6x/versions/PV9KcrYQ/ScalableLux-0.1.6%2Bfabric.c25518a-all.jar";
              sha256 = "1hjgbnq3b8zqy2jgh2pl4cnaqx8x4mdbamiva9awg0v171qp6jks";
            };
            simple-voice-chat = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/K5zIeqNd/voicechat-fabric-1.21.11-2.6.7.jar";
              sha256 = "1h0qzcjx6n9c4brvcspx078bwj260a5pd0w6aa6pmb1k0145i18h";
            };
          }
        );
      };
    };
  };
}
