{ ... }:
{
  networking.hostName = "ponos";

  fileSystems."/mnt/nas" = {
    device = "192.168.0.230:/volume1/Media";
    fsType = "nfs";
    options = [ "nofail" "x-systemd.automount" "x-systemd.device-timeout=10s" ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # caddy firewall ports
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.caddy = {
    enable = true;
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
