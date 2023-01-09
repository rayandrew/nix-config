{ lib, stdenv, fetchFromGitHub, sqlite }:

let
  inherit (stdenv.hostPlatform) system;
in

stdenv.mkDerivation rec {
  pname = "sketchybar-island-helper";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "crissNb";
    repo = "Dynamic-Island-Sketchybar";
    rev = "1c4cc958ac96e7dcc9aac4fa066eba9616696f26";
    sha256 = "1w9d0dxzpi08bk50zgn0f0qs8b1wfgk3v79r30v4bb4i1x259g9s";
  }; 

  patches = [ ./patches/change-path.diff ];

  buildInputs = [ sqlite ];
  # makeFlags = [
  #   "helper"
  # ];

  buildPhase = ''
    PATH=/usr/bin:/bin cd helper && /usr/bin/make islandhelper && cd ..
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out
    ls .
    cp helper/islandhelper $out/bin/island-helper
  '';

  meta = with lib; {
    description = "SketchyBar Island Helper";
    homepage = "https://github.com/crissNb/Dynamic-Island-Sketchybar";
    platforms = platforms.darwin;
    maintainers = [ maintainers.rayandrew ];
    license = licenses.gpl3;
  };
}
