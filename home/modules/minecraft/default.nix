{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.minecraft;
  helpers = import ./helpers.nix { inherit lib pkgs; };
in
{
  options = {
    programs.minecraft = {
      enable = mkEnableOption "Minecraft";
      # versions = mkOption {
      #   type = types.listOf types.str;
      #   default = [ "1.20.1" ];
      #   description = "Minecraft versions to install";
      # };
      options = mkOption {
        description = "Minecraft options";
        type = with types; attrsOf (submodule {
          options = {
            guiScale = mkOption { type = int; };
          };
        });
      };
    };
  };

  config =
    let
      client = (helpers.buildMinecraftClient { version = "1.20.1"; username = "boop"; });
    in
    mkIf cfg.enable
  {
    home.file.".minecraft/clients/1.20.1/run".source = "${client}/run";
    home.file.".minecraft/clients/1.20.1/options.txt".text = ''
      guiScale:2
    '';
  };
}
