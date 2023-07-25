{
  description = "Home Manager configuration of mateus";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-davinci.url =
      "github:jshcmpbll/nixpkgs?rev=391eaa6e7106c0e91e77073a1496b8548b68438b"; # TODO: Remover após atualização do nixos-23.05
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = { nur, home-manager, nixpkgs, nixpkgs-davinci, nixpkgs-unstable, ... }:
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
        overlays = [ nur.overlay overlay-unstable overlay-davinci ];
      };
    in {
      homeConfigurations."mateus" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
        ];
      };
    };
}
