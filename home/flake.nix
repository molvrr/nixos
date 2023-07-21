{
  description = "Home Manager configuration of mateus";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-bleeding.url = "github:nixos/nixpkgs";
    nixpkgs-davinci.url =
      "github:jshcmpbll/nixpkgs?rev=391eaa6e7106c0e91e77073a1496b8548b68438b";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixpkgs-bleeding, nixpkgs-davinci, ... }:
    let
      system = "x86_64-linux";
      overlay-superbleeding = final: prev: {
        superbleeding = import nixpkgs-bleeding {
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
            nixpkgs.overlays = [ overlay-superbleeding overlay-davinci ];
          })
          ./home.nix
        ];
      };
    };
}
