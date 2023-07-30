{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    wev
    waybar
    eww-wayland
    wofi
    hyprpaper
    mpvpaper
    wl-clipboard
    grim
    slurp
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      monitor = [ "eDP-1,1920x1080,auto,1" "HDMI-A-1,2560x1080,auto,1" ];
      exec-once = "mattermost-desktop & firefox & hyprpaper";
      input = {
        kb_layout = "br,us";
        kb_variant = "abnt2,intl";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;
        touchpad = { natural_scroll = false; };
        sensitivity = 0;
      };

      general = {
        gaps_in = 10;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(f81188c2) rgba(ff0038c2) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 3;
        blur = true;
        blur_size = 7;
        blur_passes = 3;
        blur_new_optimizations = true;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "windowsMove, 0, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 0, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      gestures = { workspace_swipe = false; };

      "device:epic-mouse-v1" = { sensitivity = -0.5; };

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, Return, exec, alacritty"
        "$mainMod, Q, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, V, togglefloating,"
        "$mainMod, D, exec, wofi --show drun"
        "$mainMod, P, pseudo, # dwindle"
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        "$mainMod, H, movefocus, l"
        "$mainMod, H, changegroupactive, b"
        "$mainMod, L, changegroupactive, f"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        "$mainMod, F, fullscreen, 0"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod, minus, togglespecialworkspace,"
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
        "$mainMod SHIFT, minus, movetoworkspacesilent, special"
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, J, movewindow, d"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod, I, pin,"
        "$mainMod, W, togglegroup,"
        "$mainMod, code:47, exec, notify-send $SHELL"
        '', Print, exec, grim -g "$(slurp)" - | wl-copy''
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      env = [ "XCURSOR_SIZE, 32" ];

      windowrule = [
        "float,title:^(Firefox — Sharing Indicator)$"
        "float,title:^(Bitwarden)$"
      ];

      "device:keychron-k3" = {
        kb_layout = "us,br";
        kb_variant = "intl,abnt2";
        kb_model = "";
        kb_options = "grp:alt_shift_toggle";
      };
    };
  };

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
  };
}