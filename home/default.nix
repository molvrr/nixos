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
    # ./modules/minecraft.nix
    ./modules/hyprland.nix
    ./modules/mpv.nix
    ./modules/tmux.nix
  ];

  programs.home-manager.enable = true;
  home.username = "mateus";
  home.homeDirectory = "/home/mateus";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    (xsane.override { gimpSupport = true; })
    alacritty
    alejandra
    aria2
    asciinema
    bitwarden
    blender
    bottom
    cachix
    calibre
    coreutils # stdbuf - eww (hypr)
    direnv
    discord
    dive
    doctl
    fd
    ffmpeg
    firefox
    fzf
    gawk
    gcc
    gh
    gimp
    git-crypt
    gnome.nautilus
    gnumake
    godot_4
    google-chrome
    graphviz
    heroic
    htmlq
    imagemagick
    jq
    krita
    libnotify
    libsForQt5.okular
    lutris
    maim
    mgba
    ncdu
    nerdfonts
    nix-du
    nixfmt
    nodejs_20
    playerctl
    pureref
    ripgrep
    rnix-lsp
    ruby
    scrot
    sd
    socat
    spotify
    steam
    steam-tui
    steamcmd
    typst
    unzip
    valgrind
    virt-manager
    vivaldi
    webcord
    weechat
    wineWowPackages.full
    xclip
    yacreader

    soulseekqt

    # Editores
    amp
    fte
    helix
    kakoune
    micro
    emacs
    (neovim.override { extraLuaPackages = p: with p; [ moonscript ]; })
    zee
    your-editor

    youtube-dl
    zoom-us
  ];

  programs.starship = {
    enable = true;
    settings = { add_newline = false; };
    enableNushellIntegration = true;
  };

  programs.nushell = {
    shellAliases = { lg = "lazygit"; };
    package = pkgs.nushellFull;
    enable = true;
    configFile.text = ''
      $env.config = {
        cursor_shape: {
          emacs: block
        }
        show_banner: false
      }
    '';
    extraConfig = ''
      def glog [] {
        git log --pretty=format:"[%an] [%ai] %h %s" | lines | parse "[{author}] [{date}] {index} {description}" | move date --after description | upsert date { $in.date | into datetime }
      }
    '';
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

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.lazygit = { enable = true; };

  services.emacs.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
  };

  programs.git = {
    enable = true;
    userEmail = "mateuscolvr@gmail.com";
    userName = "Mateus Cruz";
  };

  gtk = {
    enable = true;
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme=1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme=1;
    };
  };
}
