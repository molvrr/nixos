# Setup
```shell
$ git clone git@github.com:molvrr/nixos.git
$ cd nixos
$ sudo nixos-rebuild switch --flake .#
$ home-manager switch --flake .#mateus
```
# Atualização
```shell
$ nix flake lock --update-input nixpkgs
```
## TODO
- [ ] Fazer home-manager seguir nixpkgs
