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
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.pantheon.enable = true;
  # services.xserver.windowManager.i3.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.exportConfiguration = true;
  services.xserver = {
    layout = "us";
    xkbVariant = "alt-intl";
  };

  # console.keyMap = "dvorak";
  console.useXkbConfig = true;

  services.printing.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ pulseaudio git ];

  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.unstable.docker;
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
        environment = {
          TZ = "America/Sao_Paulo";
        };
        volumes = [ 
          "etcPihole:/etc/pihole"
          "etcDnsmasqD:/etc/dnsmasq.d"
        ];
      };
    };
  };

  fileSystems = {
    "/mnt/Arquivos".device = "/dev/sda1";
    "/mnt/Jogos".device = "/dev/sdb1";
  };

  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
  };

  services.flatpak.enable = true;
}
