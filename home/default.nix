{ config, pkgs, ... }:
let
  dotfiles = pkgs.fetchFromGitHub {
    owner = "molvrr";
    repo = "dotfiles";
    rev = "417a613274666ce2c01ed36f20b7d56bfff87e63";
    hash = "sha256-MOVgzpjLHwemWhFFeXQ5gUwMnprtvNm6Xx5puBatKbs=";
  };

  zoxide = pkgs.zoxide.overrideAttrs (finalAttrs: prevAttrs: {
      src = pkgs.fetchFromGitHub {
          owner = "ajeetdsouza";
          repo = "zoxide";
          rev = "3022cf3686b85288e6fbecb2bd23ad113fd83f3b";
          sha256 = "sha256-ut+/F7cQ5Xamb7T45a78i0mjqnNG9/73jPNaDLxzAx8=";
        };
    });

in {
  imports = [
    # ./modules/dunst.nix
    # ./modules/i3.nix
    # ./modules/minecraft.nix
    ./modules/hyprland.nix
    ./modules/mpv.nix
    ./modules/tmux.nix
    ./modules/neovim.nix
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
    amberol
    anki
    aria2
    artem
    asciinema
    aseprite-unfree
    awscli
    babashka
    bat
    bitwarden
    blender
    bottom
    bundix
    cachix
    calibre
    clang-tools
    cloc
    cmus
    coreutils # stdbuf - eww (hypr)
    davinci-resolve
    dhall
    haskellPackages.dhall-json
    haskellPackages.dhall-toml
    haskellPackages.dhall-bash
    helvum
    direnv
    discord
    dive
    doctl
    droidcam
    edgedb
    evilpixie
    vlc
    vhs
    ttyd
    fd
    ffmpeg-full
    figlet
    file
    firefox
    fzf
    gawk
    gcc
    gdb
    gh
    ghc
    gimp
    git-crypt
    glamoroustoolkit
    gnome.nautilus
    gnumake
    godot_4
    google-chrome
    grafx2
    graphviz
    htmlq
    imagemagick
    jq
    kak-lsp
    kitty
    krita
    texlive.combined.scheme-medium
    libnotify
    libsForQt5.okular
    localstack
    lsof
    lutris
    maim
    mindustry
    mitmproxy
    mgba
    ncdu
    nerdfonts
    nix-du
    nixfmt
    nyxt
    nodejs_20
    osu-lazer
    parallel
    playerctl
    pueue
    pureref
    qpwgraph
    rpcs3
    ripgrep
    rnix-lsp
    ruby_3_3
    sapling
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
    sqlite
    steam
    steam-run
    steam-tui
    steamcmd
    surf
    termusic
    tree
    typst
    twitch-cli
    unzip
    uxplay
    unixtools.xxd
    valgrind
    virt-manager
    (vivaldi.override { proprietaryCodecs = true; })
    vscode
    webcord
    weechat
    wineWowPackages.full
    wireshark
    xsel
    xclip
    xwaylandvideobridge
    yacreader

    zig
    zls

    taskwarrior
    taskwarrior-tui
    timewarrior

    soulseekqt

    # Editores
    amp
    fte
    helix
    kakoune
    micro
    ((emacsPackagesFor emacs29).emacsWithPackages (epkgs: with epkgs; [ vterm lsp-bridge ]))
    # (neovim.override { extraLuaPackages = p: with p; [ http ]; })
    zee
    your-editor

    yt-dlp
    zoom-us
    zip
    x11vnc
    xorg.libxcvt

    ghidra
    strace
    ltrace
  ] ++ (with ocaml-ng.ocamlPackages_5_1; [ ocaml dune_3 findlib ]);

  programs.starship = {
    enable = true;
    settings = { add_newline = false; };
    enableNushellIntegration = true;
  };

  programs.nushell = {
    shellAliases = { lg = "lazygit"; tt = "taskwarrior-tui"; };
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
    package = zoxide;
    enableNushellIntegration = true;
  };

  programs.carapace = {
    enable = false;
    enableNushellIntegration = true;
  };

  programs.lazygit = { enable = true; };

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

  home.file.".task/hooks/on-modify.timewarrior" =
  let
    code = ./timewarrior-hook.timewarrior;
  in
  {
    text = ''
    #!${pkgs.python3}/bin/python3
    ${builtins.readFile code}
    '';
    executable = true;
  };

  news.display = "silent";
}
