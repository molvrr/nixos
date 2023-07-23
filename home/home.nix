{ config, pkgs, ... }:
let
  dotfiles = pkgs.fetchFromGitHub {
    owner = "molvrr";
    repo = "dotfiles";
    rev = "5123b38086e0ed0df3b75d2520d44854e958b7bf";
    hash = "sha256-zWJNM1rwiAMxyy5y0mFl8pWia5DGRW3xuziWyNHKi3s=";
  };
in {
  imports = [
    ./modules/dunst.nix
    ./modules/i3.nix
    ./modules/minecraft.nix
    ./modules/mpv.nix
    ./modules/tmux.nix
  ];

  programs.home-manager.enable = true;
  home.username = "mateus";
  home.homeDirectory = "/home/mateus";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    alacritty
    alejandra
    aria2
    bitwarden
    blender
    calibre
    davinci.davinci-resolve
    direnv
    discord
    emacs
    fd
    ffmpeg
    firefox
    fzf
    gcc
    gh
    gnumake
    imagemagick
    krita
    libnotify
    lutris
    mgba
    neovim
    nerdfonts
    nixfmt
    nodejs_20
    nyxt
    obs-studio
    osu-lazer
    pinentry
    playerctl
    ripgrep
    rnix-lsp
    ruby
    spotify
    steam
    typst
    virt-manager
    weechat
    wineWowPackages.full
    xclip
    xdg-desktop-portal-gtk
    yacreader
    youtube-dl
    zoom-us
  ];

  programs.starship = {
    enable = true;
    settings = { add_newline = false; };
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;
    configFile.source = "${dotfiles}/nushell/config.nu";
    envFile.source = "${dotfiles}/nushell/env.nu";
  };
}
