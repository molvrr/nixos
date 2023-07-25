{ config, pkgs, ... }:
let
  dotfiles = pkgs.fetchFromGitHub {
    owner = "molvrr";
    repo = "dotfiles";
    rev = "417a613274666ce2c01ed36f20b7d56bfff87e63";
    hash = "sha256-MOVgzpjLHwemWhFFeXQ5gUwMnprtvNm6Xx5puBatKbs=";
  };
in {
  imports = [
    # ./modules/dunst.nix
    # ./modules/i3.nix
    ./modules/minecraft.nix
    ./modules/hyprland.nix
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
    godot_4
    htmlq
    imagemagick
    krita
    libnotify
    lutris
    maim
    spotify-tui

    waybar
    wofi
    hyprpaper
    mpvpaper

    scrot
    sd
    mgba
    neovim
    nerdfonts
    nixfmt
    nodejs_20
    obs-studio
    osu-lazer
    playerctl
    ripgrep
    rnix-lsp
    ruby
    spotify
    steam
    typst
    virt-manager
    vivaldi
    weechat
    wineWowPackages.full
    xclip
    yacreader
    youtube-dl
    zoom-us
  ];

  programs.starship = {
    enable = true;
    settings = { add_newline = false; };
    enableNushellIntegration = true;
  };

  programs.nushell = { enable = true; };

  programs.feh = {
    enable = true;
    buttons = {
      zoom = null;
      zoom_in = 4;
      zoom_out = 5;
      pan = 2;
    };
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.lazygit = { enable = true; };

  programs.qutebrowser = {
    enable = true;
    package = pkgs.qutebrowser-qt6;
    keyBindings = { normal = { "<Ctrl-v>" = "spawn mpv {url}"; }; };
  };

  services.emacs.enable = true;
  services.mako.enable = true;
}
