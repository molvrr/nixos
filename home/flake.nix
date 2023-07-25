{
  description = "Home Manager configuration of mateus";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-davinci.url =
      "github:jshcmpbll/nixpkgs?rev=391eaa6e7106c0e91e77073a1496b8548b68438b"; # TODO: Remover após atualização do nixos-23.05
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
  };

  outputs = { nur, home-manager, nixpkgs, nixpkgs-davinci, ... }:
    let
      system = "x86_64-linux";
      overlay-davinci = final: prev: {
        davinci = import nixpkgs-davinci {
          inherit system;
          config.allowUnfree = true;
        };
      };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nur.overlay overlay-davinci ];
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
