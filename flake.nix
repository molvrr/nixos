{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    ssbm.url = "github:djanatyn/ssbm-nix";
    neovim.url = "github:nix-community/neovim-nightly-overlay";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    feh-patch.url = "github:CharlzKlug/nixpkgs";
  };

  outputs = { self, home-manager, nixpkgs, ssbm, neovim, feh-patch }:
    let
      system = "x86_64-linux";
      feh-pkg = feh-patch.legacyPackages.${system};
      feh-overlay = prev: final: {
        feh = feh-pkg.feh;
      };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ ssbm.overlay neovim.overlay feh-overlay ];
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit pkgs;
        modules = [ ./system ];
      };

      homeConfigurations."mateus" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home ];
      };
    };
}
