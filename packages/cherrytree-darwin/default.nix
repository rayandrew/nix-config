{ pkgs
, lib
, stdenv
, ...
}:

let
  version = "0.99.52+29";
  srcs = {
    x86_64-darwin = pkgs.fetchurl {
      name = "CherryTree-${version}-x86_64-darwin.dmg";
      url = "https://gitlab.com/api/v4/projects/40236162/packages/generic/cherrytree_macos/0.99.52%2B29/CherryTree-${version}_x86_64.dmg";
      sha256 = "sha256-Ua9KK4kHJiplW0J6uvPlvUqSIbRA3REfVe8dtq34Clk=";
    };
    aarch64-darwin = pkgs.fetchurl {
      name = "CherryTree-${version}-aarch64-darwin.dmg";
      url = "https://gitlab.com/api/v4/projects/40236162/packages/generic/cherrytree_macos/0.99.52%2B29/CherryTree-${version}_arm64.dmg";
      sha256 = "sha256-Ed6vQflQImMtb7mrsA/hq/e/H2k2sv2GGHnWwS3nT0I=";
    };
  };
  src = srcs.${stdenv.hostPlatform.system};
in
pkgs.stdenv.mkDerivation rec {
  inherit version src;

  pname = "cherrytree-darwin";

  buildInputs = [ pkgs.undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p $out/Applications
    # ls -la .
    cp -r Cherrytree*.app "$out/Applications/"
  '';

  meta = {
    description = "CherryTree: Note Taking";
    homepage = "https://www.giuspen.net/cherrytree/";
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
