{
  description = "Home Manager configuration of mateus";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-davinci.url =
      "github:jshcmpbll/nixpkgs?rev=391eaa6e7106c0e91e77073a1496b8548b68438b"; # TODO: Remover após atualização do nixos-23.05
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft.url = "github:12Boti/nix-minecraft";
  };

  outputs = { nixpkgs, home-manager, nixpkgs-unstable, nixpkgs-davinci, nix-minecraft, ... }:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      overlay-davinci = final: prev: {
        davinci = import nixpkgs-davinci {
          inherit system;
          config.allowUnfree = true;
        };
      };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations."mateus" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = [ overlay-unstable overlay-davinci ];
          })
          # nix-minecraft.nixosModules.home-manager.minecraft
          ./modules/minecraft
          ./home.nix
        ];
      };
    };
}
