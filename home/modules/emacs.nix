{ config, pkgs, ... }: {
  home.file.".emacs.d".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/dotfiles/emacs";
}
