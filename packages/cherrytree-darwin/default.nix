{ pkgs
, lib
, stdenv
, ...
}:


pkgs.stdenv.mkDerivation rec {
  pname = "cherrytree";
  version = "0.99.49";

  src = pkgs.fetchFromGitHub {
    owner = "giuspen";
    repo = "cherrytree";
    rev = version;
    sha256 = "sha256-p7kiOxy4o0RwmN3LFfLSpkz08KcYYMVxVAEUvAX1KEA=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = with pkgs; [
    gtkmm3
    gtksourceview
    gtksourceviewmm
    gspell
    libxmlxx
    sqlite
    curl
    libuchardet
    spdlog
  ];

  meta = with lib; {
    description = "An hierarchical note taking application";
    longDescription = ''
      Cherrytree is an hierarchical note taking application, featuring rich
      text, syntax highlighting and powerful search capabilities. It organizes
      all information in units called "nodes", as in a tree, and can be very
      useful to store any piece of information, from tables and links to
      pictures and even entire documents. All those little bits of information
      you have scattered around your hard drive can be conveniently placed into
      a Cherrytree document where you can easily find it.
    '';
    homepage = "https://www.giuspen.com/cherrytree";
    changelog = "https://raw.githubusercontent.com/giuspen/cherrytree/${version}/changelog.txt";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}

#
# let
#   version = "0.99.52+29";
#   srcs = {
#     x86_64-darwin = pkgs.fetchurl {
#       name = "CherryTree-${version}-x86_64-darwin.dmg";
#       url = "https://gitlab.com/api/v4/projects/40236162/packages/generic/cherrytree_macos/0.99.52%2B29/CherryTree-${version}_x86_64.dmg";
#       sha256 = "sha256-Ua9KK4kHJiplW0J6uvPlvUqSIbRA3REfVe8dtq34Clk=";
#     };
#     aarch64-darwin = pkgs.fetchurl {
#       name = "CherryTree-${version}-aarch64-darwin.dmg";
#       url = "https://gitlab.com/api/v4/projects/40236162/packages/generic/cherrytree_macos/0.99.52%2B29/CherryTree-${version}_arm64.dmg";
#       sha256 = "sha256-Ed6vQflQImMtb7mrsA/hq/e/H2k2sv2GGHnWwS3nT0I=";
#     };
#   };
#   src = srcs.${stdenv.hostPlatform.system};
# in
# pkgs.stdenv.mkDerivation rec {
#   inherit version src;
#
#   pname = "cherrytree-darwin";
#
#   buildInputs = [ pkgs.undmg ];
#   sourceRoot = ".";
#   phases = [ "unpackPhase" "installPhase" ];
#   installPhase = ''
#     mkdir -p $out/Applications
#     # ls -la .
#     cp -r Cherrytree*.app "$out/Applications/"
#   '';
#
#   meta = {
#     description = "CherryTree: Note Taking";
#     homepage = "https://www.giuspen.net/cherrytree/";
#     platforms = [ "x86_64-darwin" "aarch64-darwin" ];
#   };
# }
