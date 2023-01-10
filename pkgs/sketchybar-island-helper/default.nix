{ lib, stdenv, fetchFromGitHub, sqlite }:

let
  inherit (stdenv.hostPlatform) system;
in

stdenv.mkDerivation rec {
  pname = "sketchybar-island-helper";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "crissNb";
    repo = "Dynamic-Island-Sketchybar";
    rev = "33ebf4437d4addb7a91a44939fe772b4aeb63ee7";
    sha256 = "1zvnmw7kg0q3ly925zgw80135nj9vz10wqkmmz18747y0zlaqm3c";
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
    # cp helper/islandhelper $out/bin/island-helper
  '';

  meta = with lib; {
    description = "SketchyBar Island Helper";
    homepage = "https://github.com/crissNb/Dynamic-Island-Sketchybar";
    platforms = platforms.darwin;
    maintainers = [ maintainers.rayandrew ];
    license = licenses.gpl3;
  };
}
