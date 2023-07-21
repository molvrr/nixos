{ config, pkgs, ... }:

{
  home.username = "mateus";
  home.homeDirectory = "/home/mateus";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    aria2
    blender
    bitwarden
    calibre
    davinci.davinci-resolve
    discord
    ffmpeg
    gh
    krita
    lutris
    minecraft
    mgba
    nodejs_20
    nyxt
    obs-studio
    rnix-lsp
    spotify
    steam
    virt-manager
    yacreader
    zoom-us
    wineWowPackages.full
    youtube-dl
    weechat
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
    # ".emacs.d" = {
    #   source = "${dotfiles}/emacs/.emacs.d";
    #   recursive = true;
    # };
    ".tmux.conf".source = "${dotfiles}/tmux/.tmux.conf";
  };

  programs.home-manager.enable = true;

  programs.mpv = {
    enable = true;
    bindings = {
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
    };
    config = {
      slang = "eng,fr,pt";
      alang = "jpn,eng,pt";
      geometry = "50%:50%";
      volume = "75";
    };
  };
}
