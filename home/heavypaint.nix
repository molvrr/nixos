{ stdenv, fetchzip, makeWrapper, steam-run }:
stdenv.mkDerivation rec {
  pname = "heavypaint";
  version = "2.7.71";
  src = fetchzip {
    url =
      "https://s3.us-west-1.wasabisys.com/heavypaint/builds/HEAVYPAINT_LINUX_${version}.zip";
    hash = "sha256-Jumld8bgVWCQC1seaXf8JdSXvsSj12WwUI3UyPXZLug=";
  };
  nativeBuildInputs = [ makeWrapper ];
  dontStrip = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv HEAVYPAINT.x86_64 $out/bin/HEAVYPAINT.x86_64

    makeWrapper ${steam-run}/bin/steam-run $out/bin/heavypaint \
      --add-flags $out/bin/HEAVYPAINT.x86_64
    runHook postInstall
  '';
}
