{ lib, stdenv, fetchFromGitHub }:

let
  inherit (stdenv.hostPlatform) system;
in

stdenv.mkDerivation rec {
  pname = "sketchybar-helper";
  version = "1.0.0";

  src = ./code;

  makeFlags = [
    "helper"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp helper $out/bin/sketchybar-helper
  '';

  meta = with lib; {
    description = "SketchyBar C/C++ Helper";
    homepage = "https://github.com/FelixKratz/SketchyBarHelper";
    platforms = platforms.darwin;
    maintainers = [ maintainers.rayandrew ];
    license = licenses.gpl3;
  };
}
