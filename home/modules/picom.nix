{ config, pkgs, ... }: {
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    shadow = true;
    # shadowOffsets = [
    #   0
    #   (-10)
    # ];
    opacityRules = [
      # "0:class_g = 'Rofi'"
    ];
    settings = {
      blur = {
        method = "dual_kawase";
        size = 10;
        deviation = 5.0;
        strength = 10;
      };
    };
  };
}
