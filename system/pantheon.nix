{ pkgs, ... }: {
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.pantheon = {
    enable = true;
    extraWingpanelIndicators = with pkgs; [
      monitor
      wingpanel-indicator-ayatana
    ];
  };

  systemd.user.services.indicatorapp = {
    description = "indicator-application-gtk3";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart =
        "${pkgs.indicator-application-gtk3}/libexec/indicator-application/indicator-application-service";
    };
  };
}
