{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [ "kvm-intel" ];

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

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
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "mateus";

  services.xserver.exportConfiguration = true;
  services.xserver = {
    layout = "us";
    xkbVariant = "alt-intl";
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

  users.users.mateus = {
    isNormalUser = true;
    description = "mateus";
    shell = pkgs.nushell;
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ pulseaudio git config.nur.repos.LuisChDev.nordvpn cacert gnomeExtensions.dash-to-dock ];

  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.docker.package = pkgs.docker;
  virtualisation.libvirtd.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  system.stateVersion = "23.05";

  services.udev = {
    enable = true;
    extraRules = ''
      KERNEL=="hidraw*", ATTRS{idVendor}=="0951", ATTRS{idProduct}=="16c4", MODE="0666"
      KERNEL=="hidraw*", ATTRS{idVendor}=="0951", ATTRS{idProduct}=="1723", MODE="0666"
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
      livebook = {
        autoStart = true;
        image = "ghcr.io/livebook-dev/livebook";
        ports = [ "6080:8080/tcp" "6081:8081/tcp"];
        volumes = [ "/home/mateus/livebook:/data" ];
        user = "1000:100";
      };
    };
  };

  fileSystems = {
    "/mnt/Arquivos".device = "/dev/disk/by-uuid/8EF4F408F4F3F077";
  };

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  hardware.nvidia = { modesetting.enable = true; };

  nix.settings.trusted-substituters =
    [ "https://anmonteiro.nix-cache.workers.dev" "https://devenv.cachix.org" ];

  environment.sessionVariables = rec {
    TZ = "${config.time.timeZone}";
    # WLR_NO_HARDWARE_CURSORS = "1";
    # NIXOS_OZONE_WL = "1";
    # GTK_USE_PORTAL = "1";
  };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-gtk
  #     # xdg-desktop-portal-hyprland
  #   ];
  # };

  hardware.sane.enable = true;

  hardware.sane.extraBackends = [ pkgs.epkowa pkgs.utsushi ];

  services.udev.packages = [ pkgs.utsushi ];
  services.flatpak.enable = true;

  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
  };

  networking.firewall.allowedTCPPorts = [ 7000 7001 7100 8080 ];
  networking.firewall.allowedUDPPorts = [ 5353 6000 6001 7011 ];

  # To enable network-discovery
  services.avahi = {
    enable = true;
    nssmdns = true;  # printing
    openFirewall = true; # ensuring that firewall ports are open as needed
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
      domain = true;
    };
  };

  services.komga.enable = true;

  powerManagement.cpuFreqGovernor = "performance";
}
