{ config, pkgs, ... }:
{
  programs.home-manager.enable = true;
  home.username = "mateus";
  home.homeDirectory = "/home/mateus";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [ ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  news.display = "silent";
}
