{
  config,
  pkgs,
  ...
}: {
  home.username = "mateus";
  home.homeDirectory = "/home/mateus";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["SourceCodePro"];})
    aria2
    bitwarden
    blender
    calibre
    davinci.davinci-resolve
    discord
    ffmpeg
    gh
    imagemagick
    krita
    libnotify
    lutris
    mgba
    nodejs_20
    nyxt
    obs-studio
    osu-lazer
    pinentry
    playerctl
    rnix-lsp
    spotify
    steam
    virt-manager
    weechat
    wineWowPackages.full
    yacreader
    youtube-dl
    zoom-us
  ];

  home.file = let
    rofi-themes = pkgs.fetchFromGitHub {
      owner = "adi1090x";
      repo = "rofi";
      rev = "4ede82c488d45803ca0ffbc062154373025d14ac";
      hash = "sha256-pF3qSKDtDhvviMqVPk6WKIQjt5XI0ZuD+g97c3sncTU=";
    };

    dotfiles = pkgs.fetchFromGitHub {
      owner = "molvrr";
      repo = "dotfiles";
      rev = "d14407e028cd99d3bbf82746ba07a66e9ff512f4";
      hash = "sha256-DrsXNMo0N5I91ojLp3Ey6/2kUCAX35qbzAjceO/7JQs=";
    };
  in {
    ".config/nvim" = {
      source = "${dotfiles}/nvim/.config/nvim";
      recursive = true;
    };
    # ".emacs.d" = {
    #   source = "${dotfiles}/emacs/.emacs.d";
    #   recursive = true;
    # };
    ".tmux.conf".source = "${dotfiles}/tmux/.tmux.conf";

    ".config/rofi" = {
      source = "${rofi-themes}/files";
      recursive = true;
    };

    ".local/share/fonts" = {
      source = "${rofi-themes}/fonts";
      recursive = true;
    };
  };

  programs.home-manager.enable = true;

  programs.minecraft.enable = true;

  programs.mpv = {
    enable = true;
    bindings = {
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
    };
    config = {
      slang = "eng,fr,pt";
      alang = "jpn,eng,pt";
      geometry = "50%:50%";
      volume = "75";
    };
  };

  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
  };

  services.dunst.enable = true;

  xsession.enable = true;

  services.polybar = {
    enable = true;
    script = "polybar top &";
    config = {
      "colors" = {
        background = "#282A2E";
        background-alt = "#373B41";
        foreground = "#C5C8C6";
        primary = "#F0C674";
        secondary = "#8ABEB7";
        alert = "#A54242";
        disabled = "#707880";
      };

      "bar/top" = {
        width = "100%";
        height = "24pt";
        radius = 6;
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";
        line-size = "3pt";
        border-size = "4pt";
        border-color = "#00000000";
        padding-left = 0;
        padding-right = 1;
        module-margin = 1;
        separator = "|";
        separator-foreground = "\${colors.disabled}";
        font-0 = "monospace";

        tray-position = "right";

        modules-left = "xworkspaces xwindow";
        # modules-right = "filesystem pulseaudio xkeyboard memory cpu wlan eth date";
        modules-right = "filesystem alsa xkeyboard date";
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
        enable-ipc = true;
      };

      "module/alsa" = {
        type = "internal/alsa";
        format-volume-prefix = "VOL ";
        format-volume-prefix-foreground = "\${colors.primary}";
        format-volume = "<label-volume>";
        label-volume = "%percentage%%";
        label-muted = "muted";
        label-muted-foreground = "\${colors.disabled}";
      };

      "module/xkeyboard" = {
        type = "internal/xkeyboard";
        blacklist-0 = "num lock";

        label-layout = "%layout%";
        label-layout-foreground = "\${colors.primary}";

        label-indicator-padding = 2;
        label-indicator-margin = 1;
        label-indicator-foreground = "\${colors.background}";
        label-indicator-background = "\${colors.secondary}";
      };

      "module/filesystem" = {
        type = "internal/fs";
        interval = 25;
        mount-0 = "/";
        label-mounted = "%{F#F0C674}%mountpoint%%{F-} %percentage_used%%";
        label-unmounted = "%mountpoint% not mounted";
        label-unmounted-foreground = "\${colors.disabled}";
      };

      "module/date" = {
        type = "internal/date";
        internal = 1;
        date = "%H:%M:%S";
        label = "%date%";
        label-foreground = "\${colors.foreground}";
      };

      "module/xworkspaces" = {
        type = "internal/xworkspaces";

        label-active = "%name%";
        label-active-background = "\${colors.background-alt}";
        label-active-underline = "\${colors.primary}";
        label-active-padding = 1;
        label-occupied = "%name%";
        label-occupied-padding = 1;
        label-urgent = "%name%";
        label-urgent-background = "\${colors.alert}";
        label-urgent-padding = 1;

        label-empty = "%name%";
        label-empty-font = "\${colors.disabled}";
        label-empty-padding = 1;
      };

      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
      };
    };
  };

  xsession.windowManager.i3 = let
    mod = "Mod4";
  in {
    enable = true;
    config = {
      modifier = mod;
      fonts = {
        names = ["SourceCodePro Nerd Font Mono"];
        size = 11.0;
      };

      keybindings = pkgs.lib.mkOptionDefault {
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        "${mod}+h" = "focus left";
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
        "XF86AudioNext" = "exec --no-startup-id playerctl next";
        "XF86AudioPrev" = "exec --no-startup-id playerctl previous";
        "--release Print" = "exec (import png:- | xclip -t image/png -selection clipboard)";
      };

      terminal = "alacritty";

      window.titlebar = false;
      # menu = "rofi -show combi";
      menu = "rofi -show drun -theme ~/.config/rofi/launchers/type-1/style-2.rasi";
      bars = [];
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override {plugins = with pkgs; [rofi-emoji rofi-calc];};
    theme = "gruvbox-dark-hard";
    extraConfig = {
      modes = "window,drun,emoji,calc";
      combi-modes = "window,drun,emoji";
      show-icons = true;
    };
  };
}
