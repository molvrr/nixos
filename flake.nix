{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-ocaml.url = "github:nix-ocaml/nix-overlays";
    ssbm.url = "github:djanatyn/ssbm-nix";
    neovim.url = "github:nix-community/neovim-nightly-overlay";
    neovim.inputs.nixpkgs.follows = "nixpkgs";
    feh-patch.url = "github:CharlzKlug/nixpkgs";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, home-manager, nixpkgs, ssbm, neovim, ... }@inputs:
    let
      system = "x86_64-linux";
      feh-pkg = inputs.feh-patch.legacyPackages.${system};
      feh-overlay = prev: final: { feh = feh-pkg.feh; };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays =
          [ ssbm.overlay neovim.overlay feh-overlay inputs.nix-ocaml.overlays.default ];
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit pkgs;
        modules = [ ./system ];
      };

      homeConfigurations."mateus" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home inputs.nixvim.homeManagerModules.nixvim ];
      };
    };
}
