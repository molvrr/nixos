{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    tofi
  ];

  xdg.configFile."tofi/config".source = ./tofi.conf;
}
