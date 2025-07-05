{ pkgs , ... }:
{
  networking.hostName = "transmission";

  # torrent client
  services.transmission = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nas-mount" ''
      set -e
      MOUNT_POINT="/mnt/nas"
      REMOTE="192.168.0.230:/volume1/Media"

      mkdir -p "$MOUNT_POINT"
      echo "Mounting NAS..."
      sudo mount -t nfs -o nolock "$REMOTE" "$MOUNT_POINT"
      echo "Mounted at $MOUNT_POINT."
    '')

    (pkgs.writeShellScriptBin "nas-umount" ''
      set -e
      MOUNT_POINT="/mnt/nas"

      echo "Unmounting NAS..."
      sudo umount "$MOUNT_POINT"
      echo "Unmounted."
    '')
  ];
}
