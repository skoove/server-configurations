{ config, pkgs, inputs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # storage optimisation
  nix.optimise = {
    automatic = true;
    persistent = true;
    dates = [ "18:00" ];
  };
  
  programs.nh = {
    enable = true;
    flake = "/home/zie/.dotfiles";
    clean = {
      enable = true;
      dates = "daily";
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users = {
    mutableUsers = false;

    users = {
      root = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQVpPsMT/TM3XRDvhg662rUJ19PbB90FejdkYvtF8wj zie@nixos-desktop"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnGnBgccjncw0VMcpn/qjauAugKrTSzkIjLKssgVG9z zie@nixos-laptop"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKr8Mgmz+maboqYASe3ghR2zAtKqxsPVsMfBcBjpD5GA zane@DESKTOP-JA5OSPR"
        ];
        hashedPassword = "$6$aov1GUFdGTykn2Bu$T3PL3N3I6I5N9639YhsJqKk.gMkoAm2m7tqHhaAaxg8.T4/E6fG8f8pDy5931cNTTifoZz6lpTQuFuNoO98Ql1";
      };
    
      zie = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
        hashedPassword = "$6$OlvFrwWdhd1VlHoC$kinv7.fERmkcwrDTg6e9QFFlAiL8Twd3.ljmB3yNLqS1wpb93hNVWJY6jglJYFJG/z/teAAGlqtrWquJX3rM21";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQVpPsMT/TM3XRDvhg662rUJ19PbB90FejdkYvtF8wj zie@nixos-desktop"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnGnBgccjncw0VMcpn/qjauAugKrTSzkIjLKssgVG9z zie@nixos-laptop"
        ];
      };

      zane = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" ];
        openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKr8Mgmz+maboqYASe3ghR2zAtKqxsPVsMfBcBjpD5GA zane@DESKTOP-JA5OSPR"];
        hashedPassword = "$6$XPIA64bx9L1af.Ek$MOB9ddomzRY53RgMnRykYRyql7tvDP295so2bc3gdi4mGvyDGZ/HqdM9w1a7K97ItOk3GrdhwCPlyb0F32o4L.";
      };
    };
  };

  security.sudo.wheelNeedsPassword = true;

  users.defaultUserShell = pkgs.fish;

  environment.sessionVariables = {
    EDITOR = "hx";
    COLORTERM = "truecolor";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nh       # better rebuilds
    helix    # editor
    fish     # shell
    git
    zellij   # terminal multiplexer
  ];

  environment.shellAliases = { sys = "${lib.getExe pkgs.systemd-manager-tui}"; };

  programs.fish.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  services.tailscale.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
