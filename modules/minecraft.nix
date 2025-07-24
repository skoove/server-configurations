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
      jvmOpts = "-Xmx4G -Xms4G";
      package = pkgs.fabricServers.fabric-1_21_8;
      serverProperties = {
        motd = "nixos server lets goooo";
        online-mode = true;
      };
      symlinks = {
        "ops.json" = pkgs.writeTextFile {
          name = "operators-list";
          text = ''
            [
              {
                "uuid": "442b7f11-e4f8-46f1-ace0-79b5e810659d",
                "name": "Zidget_",
                "level": 4
              }
            ]
          '';
        };
      };
    };
  };
}
