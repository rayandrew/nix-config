{ pkgs
, lib
, stdenv
, fetchFromGitHub
, darwin
, ...
}:

let
  replace = {
    "aarch64-darwin" = "--replace '-arch x86_64' ''";
    "x86_64-darwin" = "--replace '-arch arm64e' '' --replace '-arch arm64' ''";
  }.${pkgs.stdenv.system};
in
stdenv.mkDerivation rec {
  pname = "fk-yabai";
  version = "c5d37c76cbeae94f648fe90feefd86eb86184df0";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "yabai";
    rev = "c5d37c76cbeae94f648fe90feefd86eb86184df0";
    sha256 = "sha256-bnOMUcss0tDyfbDyyWsrgDtzLUeESm7lEqaTHEgD/Ow=";
  };


  nativeBuildInputs = with pkgs; [
    xcbuild
    # ncurses
    # iconv
  ];

  buildInputs = with pkgs; [
    darwin.apple_sdk.frameworks.Carbon
    darwin.apple_sdk.frameworks.Cocoa
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  postPatch = ''
    substituteInPlace makefile ${replace};
  '';

  buildPhase = ''
    PATH=/usr/bin:/bin /usr/bin/make install
  '';



  installPhase = ''
    runHook preInstall

    install -Dm755 bin/yabai $out/bin/yabai

    runHook postInstall
  '';

  meta = with lib; {
    description = "";
    homepage = "https://github.com/FelixKratz/yabai";
    license = licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = [ maintainers.rayandrew ];
  };

}
