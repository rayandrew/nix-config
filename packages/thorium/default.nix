{ pkgs
, lib
, ...
}:

{
  thorium-darwin = pkgs.stdenv.mkDerivation rec {
    pname = "Thorium-Darwin";
    version = "M113.0.5672.177";

    buildInputs = [ pkgs.undmg ];
    sourceRoot = ".";
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p $out/Applications
      cp -r Thorium*.app "$out/Applications/"
    '';

    src = pkgs.fetchurl {
      name = "Thorium_MacOS_ARM64.dmg";
      url = "https://github.com/Alex313031/Thorium-Special/releases/download/${version}/Thorium_MacOS_ARM64.dmg";
      sha256 = "sha256-ZiGOJvX3DVNClwpLYctkH81Fd68H3PSxo0R0UNhvBG4=";
    };

    meta = {
      description = "Thorium - The fastest browser on Earth.";
      homepage = "https://thorium.rocks/";
      platforms = lib.platforms.darwin;
    };
  };
}
