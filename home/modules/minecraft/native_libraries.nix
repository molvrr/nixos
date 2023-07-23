# Native Libraries
{ pkgs ? import <nixpkgs> { } }:
deps:
let
  depDerivation = dep:
    pkgs.stdenv.mkDerivation {
      name = "deps";
      buildInputs = [ pkgs.unzip ];
      src = pkgs.fetchurl { inherit (dep) url sha1; };
      buildPhase = ''
        unzip $src -d $out
        rm -rf $out/META-INF
      '';
      unpackPhase = ":";
    };
in pkgs.stdenv.mkDerivation {
  name = "native-libraries";
  src = builtins.toFile "a" "a";
  buildInputs = builtins.map depDerivation deps;
  buildPhase = ''
    mkdir $out
    find $buildInputs -name "*.*" | xargs -i{} cp -r {} $out
  '';

  unpackPhase = ":";
}
