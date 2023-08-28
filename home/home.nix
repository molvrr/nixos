{ config, pkgs, ... }:
let
  dotfiles = pkgs.fetchFromGitHub {
    owner = "molvrr";
    repo = "dotfiles";
    rev = "417a613274666ce2c01ed36f20b7d56bfff87e63";
    hash = "sha256-MOVgzpjLHwemWhFFeXQ5gUwMnprtvNm6Xx5puBatKbs=";
  };

  heavypaint = pkgs.callPackage ./heavypaint.nix {};

  xwaylandvideobridge = pkgs.libsForQt5.callPackage ./xwaylandvideobridge.nix {};
in {
  imports = [
    # ./modules/dunst.nix
    # ./modules/i3.nix
    # ./modules/minecraft.nix
    # ./modules/hyprland.nix
    ./modules/mpv.nix
    ./modules/tmux.nix
  ];

  programs.home-manager.enable = true;
  home.username = "mateus";
  home.homeDirectory = "/home/mateus";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    (lutris.override { extraPkgs = pkgs: [ pkgs.wineWowPackages.staging ]; })
    (vivaldi.override { enableWidevine = true; proprietaryCodecs = true; })
    (waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ]; }))
    alacritty
    alejandra
    aria2
    bitwarden
    blender
    bottom
    calibre
    chez
    cmake
    coreutils # stdbuf - eww (hypr)
    dig
    direnv
    discord
    emacs-unstable
    fd
    ffmpeg
    file
    fzf
    gawk
    gcc
    gh
    ghc
    gnome.nautilus
    gnumake
    godot_4
    google-chrome
    graphviz
    grim
    haskell-language-server
    heavypaint
    heroic
    htmlq
    hyprpaper
    imagemagick
    jq
    kmonad
    krita
    libnotify
    libtool
    luajitPackages.moonscript
    maim
    mgba
    mitmproxy
    ncdu
    neovim-nightly
    nerdfonts
    nix-du
    nixfmt
    nixopsUnstable
    nyxt
    obsidian
    pciutils
    playerctl
    ripgrep
    rnix-lsp
    ruby
    sbcl
    scrcpy
    scrot
    sd
    slack
    slurp
    socat
    spotify
    steam
    steam-tui
    steamcmd
    tofi
    typst
    typst-lsp
    unstable.firefox
    unstable.logseq
    unzip
    virt-manager
    webcord
    weechat
    wineWowPackages.full
    wl-clipboard
    wofi
    wrk
    xclip
    xwaylandvideobridge
    xxd
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
    configFile.text = ''
      $env.config = {
        cursor_shape: {
          emacs: block
        }
      }
    '';
    shellAliases = { lg = "lazygit"; };
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

  # gtk = with pkgs;
  # # let
  # #   themes = pkgs.callPackage ./themes.nix {};
  # # in
  # {
  #   enable = true;
  #   theme = {
  #     name = "Juno";
  #     package = juno-theme;
  #   };
  #   # iconTheme = {
  #   #   name = "Papirus-Dark";
  #   #   package = papirus-icon-theme;
  #   # };
  #   #
  #   gtk3.extraConfig = {
  #     Settings = ''
  #       gtk-application-prefer-dark-theme=1
  #     '';
  #   };
  #
  #   gtk4.extraConfig = {
  #     Settings = ''
  #       gtk-application-prefer-dark-theme=1
  #     '';
  #   };
  #
  # };

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
    extraConfig.init.defaultBranch = "main";
  };

  # home.sessionVariables = { MOZ_ENABLE_WAYLAND = 1; GTK_IM_MODULE = "xim"; };
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      dracula-theme.theme-dracula
      vscodevim.vim
      nvarner.typst-lsp
      jdinhlife.gruvbox
      bbenoist.nix
      kamadorueda.alejandra
      brettm12345.nixfmt-vscode
      jnoortheen.nix-ide
      usernamehw.errorlens
      tomoki1207.pdf
      haskell.haskell
      justusadam.language-haskell
    ];
  };

  # i18n.inputMethod.enabled = "fcitx5";
  # i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ];
}
