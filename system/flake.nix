{
  inputs.nixpkgs.url = "nixpkgs/nixos-23.05";
  inputs.nixpkgs-docker.url = "github:nixos/nixpkgs?rev=95432a7b2e9b25f320c80bad0b2b65f0dc7d2c25";

  outputs = { self, nixpkgs, nixpkgs-docker }:
  let
      system = "x86_64-linux";
      overlay-docker = final: prev: {
        dockerzin = nixpkgs-docker.legacyPackages.${prev.system};
      };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-docker ]; })
        ./configuration.nix
      ];
    };
  };
}
