{ ... }:
{
  networking.hostName = "jellyfin";

  fileSystems."/mnt/nas" = {
    device = "192.168.0.230:/volume1/Media";
    fsType = "nfs";
    options = [ "nofail" "x-systemd.automount" "x-systemd.device-timeout=10s" ];
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "zie";
  };
}
