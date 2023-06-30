{ pkgs
, lib
, ...
}:

pkgs.stdenv.mkDerivation rec {
  pname = "Brave";
  version = "v1.52.129";

  buildInputs = [ pkgs.undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p $out/Applications
    cp -r Brave*.app "$out/Applications/"
  '';

  src = pkgs.fetchurl {
    name = "Brave-${version}.dmg";
    url = "https://github.com/brave/brave-browser/releases/download/${version}/Brave-Browser-universal.dmg";
    sha256 = "sha256-SfYbKTODRlFjuO6fmqAfplHNBYwd0MULWfScrexsfJE=";
  };

  meta = {
    homepage = "https://brave.com/";
    description = "Privacy-oriented browser for Desktop and Laptop computers";
    platforms = lib.platforms.darwin;
  };
}
