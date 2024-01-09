# Setup
```shell
$ git clone git@github.com:molvrr/nixos.git
$ cd nixos
$ sudo nixos-rebuild switch --flake .#
$ home-manager switch --flake .#mateus
```
# Changelog
```shell
$ nvd diff ~/.local/state/nix/profiles/home-manager (home-manager build --flake .#mateus)
$ nvd diff /run/current-system (sudo nixos-rebuild build --flake .#)
```
