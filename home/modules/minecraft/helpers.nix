{ pkgs, lib, }:
let
  nativeLibs = import ./native_libraries.nix { inherit pkgs; };
  libPath = lib.makeLibraryPath [
    pkgs.libpulseaudio
    pkgs.xorg.libXcursor
    pkgs.xorg.libXrandr
    pkgs.xorg.libXxf86vm # Versions < 1.13
    pkgs.libGL
  ];
  versionManifest = {
    url = "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json";
    sha256 = "sha256-HiGfO13R/3KPuKXyglOI+YaTzf2AvyGeElciPJGiEL8=";
  };
  versionManifestData =
    builtins.fromJSON (builtins.readFile (pkgs.fetchurl versionManifest));
in {
  buildMinecraftClient = { version, username, }:
    let
      versionInfoUrl = let
        boop = lib.lists.findFirst (v: v.id == version) { }
          versionManifestData.versions;
      in pkgs.fetchurl { inherit (boop) url sha1; };
      versionInfo = builtins.fromJSON (builtins.readFile versionInfoUrl);
      assetsIndex = builtins.fromJSON (builtins.readFile
        (pkgs.fetchurl { inherit (versionInfo.assetIndex) url sha1; }));
      clientFile =
        pkgs.fetchurl { inherit (versionInfo.downloads.client) url sha1; };
      librariesData = let
        isAllowed = library:
          let
            lambda = acc: rule:
              if rule.action == "allow" then
                if rule ? os then rule.os.name == "linux" else true
              else if rule ? os then
                rule.os.name != "linux"
              else
                false;
          in if library ? rules then
            builtins.foldl' lambda false library.rules
          else
            true;
      in builtins.filter isAllowed versionInfo.libraries;
      fetchJavaLib = lib:
        pkgs.fetchurl { inherit (lib.downloads.artifact) url sha1; };
      fetchNativeLib = lib:
        pkgs.fetchurl {
          inherit (lib.downloads.classifiers.${lib.natives.linux}) url sha1;
          postFetch = "";
        };
    in pkgs.runCommand "minecraft-${version}" {
      nativeBuildInputs = [ pkgs.makeWrapper ];
      JAVA_LIBRARIES = lib.concatStringsSep ":" ([ clientFile ]
        ++ (builtins.map fetchJavaLib
          (builtins.filter (x: !(x.downloads ? "classifiers")) librariesData)));
      NATIVE_LIBRARIES = nativeLibs (builtins.map (lib: {
        inherit (lib.downloads.classifiers.${lib.natives.linux}) url sha1;
      }) (builtins.filter (x: x.downloads ? "classifiers") librariesData));
    } ''
      mkdir -p $out/bin $out/libraries $out/natives $out/assets/indexes

      makeWrapper ${pkgs.jre}/bin/java $out/run \
                  --add-flags "\$JRE_OPTIONS" \
                  --add-flags "-Djava.library.path='$NATIVE_LIBRARIES'" \
                  --add-flags "-cp '$JAVA_LIBRARIES'" \
                  --add-flags "${versionInfo.mainClass}" \
                  --add-flags "--version ${versionInfo.id}" \
                  --add-flags "--assetsDir ${
                    if versionInfo.assets == "legacy" then
                      "$out/assets/virtual/legacy"
                    else
                      "$out/assets"
                  }" \
                  --add-flags "--userProperties {}" \
                  --add-flags "--assetIndex ${versionInfo.assets}" \
                  --add-flags "--accessToken hehe" \
                  --add-flags "--username ${username}" \
                  --prefix LD_LIBRARY_PATH : "${libPath}"
    '';
}
