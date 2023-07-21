{
  inputs.nixpkgs.url = "nixpkgs/nixos-23.05";
  inputs.nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, nixpkgs-unstable }:
  let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
  in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
        ./configuration.nix
      ];
    };
  };
}
