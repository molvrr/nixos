{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/NUR";
    ssbm.url = "github:djanatyn/ssbm-nix";
  };

  outputs = { self, home-manager, nixpkgs, nur, ssbm }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ ssbm.overlay ];
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./system nur.nixosModules.nur ];
      };

      homeConfigurations."mateus" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home ];
      };
    };
}
