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
    coreutils # stdbuf - eww (hypr)
    direnv
    discord
    emacs
    fd
    ffmpeg
    firefox-wayland
    fzf
    gawk
    gcc
    gh
    gnumake
    godot_4
    htmlq
    imagemagick
    jq
    krita
    libnotify
    lutris
    maim
    mattermost-desktop
    mgba
    neovim
    nerdfonts
    nixfmt
    nodejs_20
    playerctl
    ripgrep
    rnix-lsp
    ruby
    spotify
    slack
    scrot
    sd
    socat
    spotify
    steam
    steam-tui
    steamcmd
    typst
    virt-manager
    vivaldi
    webcord
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

  programs.nushell = {
    shellAliases = {
      lg = "lazygit";
    };
    enable = true;
  };

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
  services.mako = {
    enable = true;
    defaultTimeout = 1500;
  };

  gtk = with pkgs; {
    enable = true;
    theme = {
      name = "Juno";
      package = juno-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = papirus-icon-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

  };

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/backgroundImage.jpg
    preload = ~/backgroundImage2.jpg
    wallpaper = eDP-1, ~/backgroundImage.jpg
    wallpaper = HDMI-A-1,contain:~/backgroundImage2.jpg
  '';

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
  };

  programs.git = {
    enable = true;
    userEmail = "mateuscolvr@gmail.com";
    userName = "Mateus Cruz";
  };

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
  };
}
