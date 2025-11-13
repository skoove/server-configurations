{ ... }:
{
  networking.hostname = "athena";

  services.ntfy-sh = {
    enable = true;

    settings = {
      listen-http = ":6060";
    };
  };
}
