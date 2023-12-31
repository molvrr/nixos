{ config, pkgs, ... }: {
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
}
