{ config, pkgs, ... }:

{
  home.username = "mateus";
  home.homeDirectory = "/home/mateus";
  home.stateVersion = "23.05";

  home.packages = with pkgs;
  [
    docker
    docker-compose
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    nyxt
    bitwarden
    lutris
    spotify
    discord
    krita
    calibre
    obs-studio
    mgba
    yacreader
    ffmpeg
    rnix-lsp
    aria2
    steam
    mpv
    virt-manager
    nodejs_20
    zoom-us
    gh
  ];

  home.file = let
    dotfiles = pkgs.fetchFromGitHub {
      owner = "molvrr";
      repo = "dotfiles";
      rev = "d14407e028cd99d3bbf82746ba07a66e9ff512f4";
      hash = "sha256-DrsXNMo0N5I91ojLp3Ey6/2kUCAX35qbzAjceO/7JQs=";
    };
  in {
    ".config/nvim" = {
      source = "${dotfiles}/nvim/.config/nvim";
      recursive = true;
    };
    ".emacs.d" = {
      source = "${dotfiles}/emacs/.emacs.d";
      recursive = true;
    };
    ".tmux.conf".source = "${dotfiles}/tmux/.tmux.conf";
  };

  programs.home-manager.enable = true;
}
