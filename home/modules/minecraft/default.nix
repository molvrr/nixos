{ config, lib, pkgs, ... }:
let
  cfg = config.programs.minecraft;
  inherit (lib) mkOption types mkIf foldlAttrs mkEnableOption;
  helpers = import ./helpers.nix { inherit lib pkgs; };
  mkClient = client: {
    data = helpers.buildMinecraftClient {
      version = client.version;
      username = "boop";
    };
  };

  clientType = with types;
    submodule { options = { version = mkOption { type = str; }; }; };
in {
  options = {
    programs.minecraft = {
      enable = mkEnableOption "Minecraft";
      clients = mkOption {
        description = "Minecraft client";
        type = with types; attrsOf clientType;
      };
    };
  };

  config = mkIf cfg.enable {
    home.file = (foldlAttrs (acc: clientName: val:
      let client = mkClient val;
      in acc // {
        ".minecraft/clients/${clientName}/run".source = "${client.data}/run";
      }) { } cfg.clients);
  };
}
