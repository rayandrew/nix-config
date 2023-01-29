{ lib, stdenv, fetchFromGitHub, sqlite }:

let inherit (stdenv.hostPlatform) system;

in stdenv.mkDerivation rec {
  pname = "sketchybar-shendy";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "shendypratamaa";
    repo = ".dotfiles";
    rev = "f54fc53fe70d1a8802b71f84f6472d2d872a9155";
    sha256 = "183gjqcs4gzrlcbg3qj481im8pz181cr59hl5in4dilcr16sdpd2";
    stripRoot = false;
  };

  patches = [ ./patches/001-grep.patch ];

  installPhase = ''
    mkdir -p $out
    cp -r sketchybar/.config/sketchybar/* $out
  '';

  meta = with lib; {
    description = "SketchyBar Shendy Pratama";
    homepage = "https://github.com/shendypratamaa/.dotfiles";
    platforms = platforms.darwin;
    maintainers = [ maintainers.rayandrew ];
    license = licenses.gpl3;
  };
}
