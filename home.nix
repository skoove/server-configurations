{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "zie";
  home.homeDirectory = "/home/zie";

  home.stateVersion = "24.11"; # Please read the comment before changing.
  home.packages = with pkgs; [
    helix
    zellij
    nushell
    nil
  ];

  home.file = {
  };

  catppuccin.accent = "mauve";
  catppuccin.flavor = "mocha";
  catppuccin.enable = true;

  programs.git = {
    enable = true;
    userName = "Zie Sturges";
    userEmail = "zie@sturges.com.au";
    extraConfig.init.defaultBranch = "main";
  };

  # personalisation for nushell!
  programs.nushell = { 
    enable = true;
    extraConfig = ''
      $env.config.show_banner = false
    '';
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
