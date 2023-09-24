{ config, pkgs, ... }: {
  programs.mpv = {
    enable = true;
    bindings = {
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
      R = "sub-reload";
    };
    config = {
      slang = "eng,fr,pt";
      alang = "jpn,eng,pt";
      geometry = "50%:50%";
      volume = "75";
    };
  };
}
