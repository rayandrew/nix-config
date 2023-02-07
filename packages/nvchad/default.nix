{ lib, stdenv, pkgs }:

stdenv.mkDerivation {
  pname = "nvchad";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "NvChad";
    repo = "NvChad";
    rev = "eac36d40bb2214ceb2527e8a5915e28fa2506a54";
    sha256 = "sha256-VWh6o0k+3RMhpqbRqTzsD2ceNRpsPDzm+MDqUFI6WqQ=";
  };

  installPhase = ''
    mkdir $out
    cp -r * "$out/"
  '';

  meta = with lib; {
    description = "NvChad";
    homepage = "https://github.com/NvChad/NvChad";
    platforms = platforms.all;
    maintainers = [ maintainers.rayandrew ];
    license = licenses.gpl3;
  };
}
