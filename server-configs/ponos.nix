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

  services.caddy = {
    enable = true;
    virtualHosts = {
      "proxmox-node-1.home".extraConfig = ''reverse_proxy https://192.168.0.230:8006'';
      "proxmox-node-2.home".extraConfig = ''reverse_proxy https://192.168.0.231:8006'';
    };
  };
}
