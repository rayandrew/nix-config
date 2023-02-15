{ lib, stdenv, pkgs }:

let
  custom = ./custom;
in
stdenv.mkDerivation {
  pname = "nvchad";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "32b0a008a96a3dd04675659e45a676b639236a98";
    sha256 = "sha256-IfVcysO6LTm7xFv5m7+GExmplj0P+IVGSeoMCT9qvBY=";
  };

  installPhase = ''
    mkdir $out
    cp -r * "$out/"
    mkdir -p "$out/lua/custom"
    cp -r ${custom}/* "$out/lua/custom/"
  '';

  meta = with lib; {
    description = "NvChad";
    homepage = "https://github.com/NvChad/NvChad";
    platforms = platforms.all;
    maintainers = [ maintainers.rayandrew ];
    license = licenses.gpl3;
  };
}
