{
  pkgs,
  lib,
}: let
  libPath = lib.makeLibraryPath [
    pkgs.libpulseaudio
    pkgs.xorg.libXcursor
    pkgs.xorg.libXrandr
    pkgs.xorg.libXxf86vm # Needed only for versions <1.13
    pkgs.libGL
  ];
  versionManifest = {
    url = "https://launchermeta.mojang.com/mc/game/version_manifest_v2.json";
    sha256 = "sha256-HiGfO13R/3KPuKXyglOI+YaTzf2AvyGeElciPJGiEL8=";
  };
  versionManifestData =
    builtins.fromJSON (builtins.readFile (pkgs.fetchurl versionManifest));
in {
  buildMinecraftClient = {
    version,
    username,
  }: let
    versionInfoUrl = let
      boop =
        lib.lists.findFirst (v: v.id == version) {}
        versionManifestData.versions;
    in
      pkgs.fetchurl {inherit (boop) url sha1;};
    versionInfo = builtins.fromJSON (builtins.readFile versionInfoUrl);
    assetsIndex = builtins.fromJSON (builtins.readFile (pkgs.fetchurl {inherit (versionInfo.assetIndex) url sha1;}));
    clientFile =
      pkgs.fetchurl {inherit (versionInfo.downloads.client) url sha1;};
    librariesData = let
      isAllowed = library:
        if library ? rules
        then
          builtins.foldl' (acc: rule:
            acc
            || rule.action
            == "allow"
            && rule ? os
            && rule.os.name
            == "linux")
          false
          library.rules
        else true;
    in
      builtins.filter isAllowed versionInfo.libraries;
  in
    pkgs.runCommand "minecraft-${version}" {
      nativeBuildInputs = [pkgs.makeWrapper];
    } ''
        mkdir -p $out/bin $out/libraries $out/natives $out/assets/indexes

        ln -s ${clientFile} $out/libraries/client.jar

      ${lib.concatMapStringsSep "\n" (library: ''
        mkdir -p $out/libraries/${
          builtins.dirOf library.downloads.artifact.path
        }
        ln -s ${
          pkgs.fetchurl {inherit (library.downloads.artifact) url sha1;}
        } $out/libraries/${library.downloads.artifact.path}'')
      (builtins.filter (x: !(x.downloads ? "classifiers")) librariesData)}

      ${lib.concatMapStringsSep "\n" (library: ''
        unzip ${
          pkgs.fetchurl {
            inherit
              (library.downloads.classifiers.${library.natives.linux})
              url
              sha1
              ;
          }
        } -d $out/natives && rm -rf $out/natives/META-INF
      '') (builtins.filter (x: (x.downloads ? "classifiers")) librariesData)}



        ${lib.concatStringsSep "\n" (builtins.attrValues (lib.flip lib.mapAttrs assetsIndex.objects (name: a: let
        asset = pkgs.fetchurl {
          sha1 = a.hash;
          url = "https://resources.download.minecraft.net/" + hashTwo;
        };
        hashTwo = builtins.substring 0 2 a.hash + "/" + a.hash;
        outPath =
          if versionInfo.assets == "legacy"
          then "$out/assets/virtual/legacy/${name}"
          else "$out/assets/objects/${hashTwo}";
      in ''
        mkdir -p ${builtins.dirOf outPath}
        ln -sf ${asset} ${outPath}
      '')))}
            ln -s ${builtins.toFile "assets.json" (builtins.toJSON assetsIndex)} \
                $out/assets/indexes/${versionInfo.assets}.json

        makeWrapper ${pkgs.jre}/bin/java $out/run \
                    --add-flags "\$JRE_OPTIONS" \
                    --add-flags "-cp '$(find $out/libraries -name '*.jar' | tr -s '\n' ':')'" \
                    --add-flags "${versionInfo.mainClass}" \
                    --add-flags "--accessToken hehe" \
                    --add-flags "--username ${username}" \
                    --add-flags "--assetsDir ${if versionInfo.assets == "legacy" then "$out/assets/virtual/legacy" else "$out/assets"}" \
                    --add-flags "--assetIndex ${versionInfo.assets}" \
                    --add-flags "--version ${versionInfo.id}" \
                    --prefix LD_LIBRARY_PATH : "${libPath}"
    '';
}
