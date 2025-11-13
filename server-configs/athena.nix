{ ... }:
{
  networking.hostName = "athena";

  services.ntfy-sh = {
    enable = true;

    settings = {
      listen-http = ":6060";
      base-url = "http://100.x.x.x";
    };
  };
}
