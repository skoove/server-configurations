{ inputs , pkgs , ... }:
{
  imports = [
    ../modules/minecraft.nix
  ];

  networking.hostName = "ponos";
  networking.firewall.allowedTCPPorts = [
    80 443 # caddy
    7000 # miniflux
  ];

  fileSystems."/mnt/nas" = {
    device = "192.168.0.232:/volume1/Media";
    fsType = "nfs";
    options = [ "nofail" "x-systemd.automount" "x-systemd.device-timeout=10s" ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  
  services.audiobookshelf = {
    enable = true;
    openFirewall = true;
    host = "0.0.0.0";
  };

  services.miniflux = {
    enable = true;
    config = {
      CREATE_ADMIN = 0;
      FETCH_NEBULA_WATCH_TIME = 1;
      FETCH_ODYSEE_WATCH_TIME = 1;
      LISTEN_ADDR = "0.0.0.0:7000";
    };
  };

  # caddy firewall ports
  services.caddy = {
    enable = false;
    virtualHosts = let
      mkReverseProxy = {domain, ip, tlsBackend ? false}: {
        ${domain} = {
          extraConfig = ''
            ${if tlsBackend then "tls internal" else ""}
            reverse_proxy ${ip}${if tlsBackend then ''
              transport http {
                tls
                tls_insecure_skip_verify
              }
            }
              '' else ""}
          '';
        };
      };

      proxies = [
        { domain = "proxmox-1.home.com"; ip = "192.168.0.230:8006"; tlsBackend = true; }
        { domain = "proxmox-2.home.com"; ip = "192.168.0.231:8006"; tlsBackend = true; }
        { domain = "jellyfin.home.com"; ip = "localhost:8096"; }
        { domain = "transmission.home.com"; ip = "192.168.0.211:9091"; }
      ];
    in
      builtins.foldl' (acc: val: acc // mkReverseProxy val) {} proxies;
  };
}
