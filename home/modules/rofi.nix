{ config, pkgs, ... }: {
  home.file = let
    rofi-themes = pkgs.fetchFromGitHub {
      owner = "adi1090x";
      repo = "rofi";
      rev = "4ede82c488d45803ca0ffbc062154373025d14ac";
      hash = "sha256-pF3qSKDtDhvviMqVPk6WKIQjt5XI0ZuD+g97c3sncTU=";
    };
  in {
    ".local/share/fonts" = {
      source = "${rofi-themes}/fonts";
      recursive = true;
    };

    ".config/rofi" = {
      source = "${rofi-themes}/files";
      recursive = true;
    };
  };
  programs.rofi = {
    enable = true;
    package =
      pkgs.rofi.override { plugins = with pkgs; [ rofi-emoji rofi-calc ]; };
    theme = let inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        background-color = mkLiteral "#1F1F1F";
        text-color = mkLiteral "#6B6B6B";
      };

      window = {
        width = mkLiteral "var(width, 30%)";
        padding = mkLiteral "10px";
      };

      mainbox = {
        children = map mkLiteral [ "message" "listview" "mode-switcher" ];
      };
    };
    extraConfig = {
      modes = "window,drun,emoji,calc";
      combi-modes = "window,drun,emoji";
      show-icons = true;
      window-format = "{t}";
    };
  };
}
