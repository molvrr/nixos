{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit
  ]) ++ (with pkgs.gnome; [
    cheese
    gnome-music
    gnome-terminal
    epiphany
    geary
    gnome-characters
    totem
    tali
    iagno
    hitori
    atomix
  ]);

  environment.systemPackages = with pkgs; [ gnomeExtensions.appindicator gnomeExtensions.dash-to-dock gnome3.gnome-tweaks ];
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
}
