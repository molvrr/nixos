{ config, pkgs, ... }: {
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

  home.file = let
    dotfiles = pkgs.fetchFromGitHub {
      owner = "molvrr";
      repo = "dotfiles";
      rev = "f764d9eee4fee1483bc08b84b3ec1a60c3a58e13";
      hash = "sha256-Uo4A96ZD3bHktaQn0pRaPkb8sLGeXjQGHl5xZHQ37Cw=";
    };
  in {
    # ".config/nvim" = {
    #   source = "${dotfiles}/nvim/.config/nvim";
    #   recursive = true;
    # };
    # ".emacs.d" = {
    #   source = "${dotfiles}/emacs/.emacs.d";
    #   recursive = true;
    # };
    # ".tmux.conf".source = "${dotfiles}/tmux/.tmux.conf";
  };
}
