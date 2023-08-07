{ lib, stdenv, fetchFromGitHub }:
{
  lightning-bug = stdenv.mkDerivation rec {
    pname = "LightningBug";
    version = "0.0.0";
    src = fetchFromGitHub {
      owner = "i-mint";
      repo = pname;
      rev = "master";
      hash = "sha256-F5AEYWfhNclt7s/i8N9kcfePb/iQpn8rDQdL874BmXA=";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes
      cp -a Lightningbug* $out/share/themes
      runHook postInstall
    '';
  };
}
