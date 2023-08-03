# Setup
```shell
$ git clone git@github.com:molvrr/nixos.git
$ cd nixos
$ sudo nixos-rebuild switch --flake ./system#
$ home-manager switch --flake ./home#mateus
```
# Atualização
```shell
$ nix flake lock --update-input nixpkgs
```
## TODO
- [ ] Fazer home-manager seguir nixpkgs
