{ pkgs , ... }:
{
  # the nas should be manually mounted and unmounted, this is for security
  # reasons, during torrenting do not mount the nas
   
  networking.hostName = "transmission";

  # torrent client
  services.transmission = {
    enable = true;
    openFirewall = true;
    openRPCPort = true;
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
    };
  };

  environment.systemPackages = [
    # for mounting the nfs filesytstems
    pkgs.nfs-utils

    # script to mount
    (pkgs.writeShellScriptBin "nas-mount" ''
      set -e
      MOUNT_POINT="/mnt/nas"
      REMOTE="192.168.0.230:/volume1/Media"

      sudo mkdir -p "$MOUNT_POINT"
      echo "Mounting NAS..."
      sudo mount -t nfs -o nolock "$REMOTE" "$MOUNT_POINT"
      echo "Mounted at $MOUNT_POINT."
    '')

    # script to un mount
    (pkgs.writeShellScriptBin "nas-umount" ''
      set -e
      MOUNT_POINT="/mnt/nas"

      echo "Unmounting NAS..."
      sudo umount "$MOUNT_POINT"
      echo "Unmounted."
    '')
  ];
}
