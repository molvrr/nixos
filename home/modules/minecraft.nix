{ config, pkgs, ... }: {
  imports = [ ./minecraft ];
  programs.minecraft = {
    enable = true;
    clients = {
      "1.20.1" = {
        version = "1.20.1";
        settings = {
          guiScale = 2;
          fov = 1;
        };
      };
    };
  };
}
