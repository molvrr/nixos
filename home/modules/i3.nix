{ config, pkgs, ... }: {
  imports = [ ./rofi.nix ./picom.nix ./polybar.nix ];

  xsession.enable = true;
  xsession.windowManager.i3 = let mod = "Mod4";
  in {
    enable = true;
    config = {
      modifier = mod;
      fonts = {
        names = [ "FiraCode Nerd Font Mono" ];
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
        "${mod}+semicolon" = "sticky toggle";
        "XF86AudioRaiseVolume" =
          "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" =
          "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" =
          "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
        "XF86AudioNext" = "exec --no-startup-id playerctl next";
        "XF86AudioPrev" = "exec --no-startup-id playerctl previous";
        "--release Print" =
          "exec (import png:- | xclip -t image/png -selection clipboard)";
      };

      terminal = "alacritty";

      window = {
        # hideEdgeBorders = "both";
        titlebar = false;
      };

      defaultWorkspace = "workspace number 1";

      assigns = {
        "1" = [{ class = "^firefox$"; }];
        "3" = [{ class = "^discord$"; }];
        "4" = [{ class = "^Spotify$"; }];
      };

      menu =
        "rofi -show drun -theme ~/.config/rofi/launchers/type-1/style-2.rasi";
      bars = [ ];

      floating.criteria = [
        { window_role = "pop-up"; }
        { class = "mGBA"; }
        { class = "feh"; }
        { class = "Bitwarden"; }
      ];
    };
  };
}
