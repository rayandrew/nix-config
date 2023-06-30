{ pkgs
, lib
, ...
}:

{
  vivaldi-darwin = pkgs.stdenv.mkDerivation rec {
    pname = "Vivaldi";
    version = "5.7.2921.65";

    buildInputs = [ pkgs.undmg ];
    sourceRoot = ".";
    phases = [ "unpackPhase" "installPhase" ];
    installPhase = ''
      mkdir -p $out/Applications
      cp -r Vivaldi*.app "$out/Applications/"
    '';

    src = pkgs.fetchurl {
      name = "Vivaldi-${version}.dmg";
      url = "https://downloads.vivaldi.com/stable/Vivaldi.${version}.universal.dmg";
      sha256 = "sha256-wlMiuzYPq0PIY3wJpyVxkqHWPMlnwKmS1v5vV5vbUG8=";
    };

    meta = {
      description = "Vivaldi Browser: Get unrivaled customization options and built-in browser features for better performance, productivity, and privacy.";
      homepage = "https://vivaldi.com/";
      platforms = lib.platforms.darwin;
    };
  };
}
