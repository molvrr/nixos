{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  networking.hostName = "nixos";
  # networking.wireless.enable = true;
  # networking.wireless.iwd.enable = true;
  # networking.wireless.userControlled.enable = true;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.nameservers = [
    "127.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];

  time.timeZone = "America/Maceio";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.xserver.enable = true;

  # services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.desktopManager.pantheon.enable = true;

  services.xserver.exportConfiguration = true;
  services.xserver = {
    layout = "us";
    xkbVariant = "intl";
  };

  console.useXkbConfig = true;

  services.printing.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 15d";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  users.groups.uinput = {};

  services.atd.enable = true;

  users.users.mateus = {
    isNormalUser = true;
    description = "mateus";
    shell = pkgs.nushell;
    extraGroups = [ "networkmanager" "wheel" "docker" "input" "uinput" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ pulseaudio git ];

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  system.stateVersion = "23.05";

  services.udev = {
    enable = true;
    extraRules = ''
      KERNEL=="hidraw*", ATTRS{idVendor}=="0951", ATTRS{idProduct}=="16c4", MODE="0666"
      KERNEL=="hidraw*", ATTRS{idVendor}=="0951", ATTRS{idProduct}=="1723", MODE="0666"
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
      ATTRS{name}=="Keychron K3", SYMLINK+="keychron-k3"
    '';
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      pihole = {
        autoStart = true;
        image = "pihole/pihole:2023.05.2";
        ports = [ "53:53/tcp" "53:53/udp" "80:80/tcp" ];
        environment = { TZ = "America/Sao_Paulo"; };
        volumes = [ "etcPihole:/etc/pihole" "etcDnsmasqD:/etc/dnsmasq.d" ];
      };
    };
  };

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  nix.settings.trusted-substituters =
    [ "https://anmonteiro.nix-cache.workers.dev" ];

  environment.sessionVariables = rec {
    TZ = "${config.time.timeZone}";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    GTK_USE_PORTAL = "1";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-hyprland ];
  };

  security.pki.certificateFiles = [
    ./mitmproxy-ca-cert.pem
  ];

  programs.hyprland.enable = true;
}
