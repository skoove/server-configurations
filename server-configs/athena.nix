{ ... }:
let
  ntfy-port = 6060;
in
{
  networking.hostName = "athena";

  networking.firewall.allowedTCPPorts = [ ntfy-port ];

  services.ntfy-sh = {
    enable = true;

    settings = {
      listen-http = ":${builtins.toString ntfy-port}";
      base-url = "http://100.116.46.98:${builtins.toString ntfy-port}";
    };
  };
}
