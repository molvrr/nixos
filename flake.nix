{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nur.url = github:nix-community/NUR;
  };

  outputs = { self, home-manager, nixpkgs, nur }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./system/configuration.nix nur.nixosModules.nur ];
      };

      homeConfigurations."mateus" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/home.nix ];
      };
    };
}
