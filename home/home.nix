{
  config,
  pkgs,
  ...
}: {

  imports = [
    ./modules/minecraft
  ];

  home.username = "mateus";
  home.homeDirectory = "/home/mateus";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["SourceCodePro"];})
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
    tmux
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
    rofi-themes = pkgs.fetchFromGitHub {
      owner = "adi1090x";
      repo = "rofi";
      rev = "4ede82c488d45803ca0ffbc062154373025d14ac";
      hash = "sha256-pF3qSKDtDhvviMqVPk6WKIQjt5XI0ZuD+g97c3sncTU=";
    };

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

      # "1.6.4" = {
      #   version = "1.6.4";
      # };
      #
      # "1.18" = {
      #   version = "1.18";
      # };
      #
      # "hehe" = {
      #   version = "14w07a";
      # };
    };
  };

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

 services.dunst = {
      enable = true;
      iconTheme = {
        name = "arc-icon-theme";
        package = pkgs.arc-icon-theme;
      };
      settings = {
        global = {
          monitor = 0;
          follow = "keyboard";
          geometry = "250x10-30+20";
          indicate_hidden = "yes";
          shrink = "no";
          transparency = 10;
          notification_height = 0;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          frame_width = 2;
          frame_color = "#aaaaaa"; # editar aqui
          separator_color = "auto";
          sort = "yes";
          font = "JetBrainsMono 10";
          line_height = 0;
          markup = "full";
          format = "<b>%s</b>i\\n%b";
          alignment = "center";
          show_age_threshold = 60;
          word_wrap = "yes";
          ellipsize = "middle";
          ignore_newline = "no";
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = "yes";
          icon_position = "left";
          max_icon_size = 32;
          sticky_history = "yes";
          history_length = 20;
          title = "Dunst";
          class = "dunst";
          startup_notification = false;
          verbosity = "mesg";
          corner_radius = 5;
          force_xinerama = false;
          mouse_left_click = "do_action";
          mouse_middle_click = "close_all";
          mouse_right_click = "close_current";
        };
        experimental = { per_monitor_dpi = false; };
        shortcuts = {
          close = "ctrl+space";
          close_all = "ctrl+shift+space";
          history = "ctrl+grave";
          context = "ctrl+shift+period";
        };
        urgency_low = {
          background = "#2b2b2b";
          foreground = "#ffffff";
          timeout = 2;
        };
        urgency_normal = {
          background = "#2b2b2b";
          foreground = "#ffffff";
          timeout = 2;
        };
        urgency_critical = {
          background = "#900000";
          foreground = "#ffffff";
          frame_color = "#ff0000";
          timeout = 3;
        };
      };
    };

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
        date = "%H:%M:%S %d/%m/%Y";
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

      startup = [
        { command = "firefox"; }
        { command = "spotify"; }
        { command = "discord"; }
        { command = "~/.fehbg"; }
      ];

      keybindings = pkgs.lib.mkOptionDefault {
        "${mod}+0" = "workspace number 0";
        "${mod}+Shift+0" = "move container to workspace number 0";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";
        "${mod}+h" = "focus left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
        "${mod}+Shift+h" = "move left";
        "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
        "XF86AudioNext" = "exec --no-startup-id playerctl next";
        "XF86AudioPrev" = "exec --no-startup-id playerctl previous";
        "--release Print" = "exec (import png:- | xclip -t image/png -selection clipboard)";
      };

      terminal = "alacritty";

      window =  {
        # hideEdgeBorders = "none";
        hideEdgeBorders = "both";
        titlebar = false;
      };

      defaultWorkspace = "workspace number 1";

      assigns = {
        "1" = [{ class = "^firefox$"; }];
        "3" = [{ class = "^discord$"; }];
        "4" = [{ class = "^Spotify$"; }];
      };

      menu = "rofi -show drun -theme ~/.config/rofi/launchers/type-1/style-2.rasi";
      bars = [];

      floating.criteria = [
        {
          class = "io.github.lainsce.Colorway";
        }
      ];
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
