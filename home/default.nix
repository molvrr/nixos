{ config, pkgs, ... }:
let
  dotfiles = pkgs.fetchFromGitHub {
    owner = "molvrr";
    repo = "dotfiles";
    rev = "417a613274666ce2c01ed36f20b7d56bfff87e63";
    hash = "sha256-MOVgzpjLHwemWhFFeXQ5gUwMnprtvNm6Xx5puBatKbs=";
  };

  xwaylandvideobridge = pkgs.libsForQt5.callPackage ./xwaylandvideobridge.nix {};
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
    aegisub
    alacritty
    alejandra
    aria2
    asciinema
    aseprite-unfree
    bitwarden
    blender
    bottom
    cachix
    calibre
    coreutils # stdbuf - eww (hypr)
    davinci-resolve
    direnv
    discord
    dive
    doctl
    droidcam
    dune_3
    ocaml

    fd
    ffmpeg-full
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
    htmlq
    imagemagick
    jq
    kak-lsp
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
    obsidian
    osu-lazer
    playerctl
    pureref
    ripgrep
    rnix-lsp
    ruby_3_2
    scrot
    sd
    (slippi-netplay.overrideAttrs (prev: final: rec {
      version = "3.3.1";
      src = pkgs.fetchFromGitHub {
        owner = "project-slippi";
        repo = "Ishiiruka";
        rev = "v${version}";
        hash = "sha256-06hS770zo/4XnvKc9Mtxn+cAvAF6fNXR+SRzKFNoh1Y=";
        fetchSubmodules = true;
      };

      cargoDeps = pkgs.rustPlatform.importCargoLock {
        lockFile = "${src}/${prev.cargoRoot}/Cargo.lock";
        outputHashes = {
          "cpal-0.15.2" = "sha256-4C7YWUx6SZnZy6pwy0CCL3yPgaMflN1atN3cUNMbcmU=";
        };
      };
    }))
    slippi-launcher
    socat
    spotify
    steam
    steam-run
    steam-tui
    steamcmd
    typst
    unzip
    uxplay
    valgrind
    virt-manager
    vivaldi
    vscode
    webcord
    weechat
    wineWowPackages.full
    xclip
    xwaylandvideobridge
    yacreader

    soulseekqt

    # Editores
    amp
    fte
    helix
    kakoune
    micro
    emacs
    (neovim.override { extraLuaPackages = p: with p; [ moonscript http ]; })
    zee
    your-editor

    yt-dlp
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
    enable = false;
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
