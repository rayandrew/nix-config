{ pkgs
, lib
, stdenv
, fetchFromGitHub
, darwin
, ...
}:

stdenv.mkDerivation rec {
  pname = "felixkratz-sketchybar-helper";
  version = "0.1.0";

  src = ./src;

  nativeBuildInputs = [
  ];

  # buildInputs = with pkgs; [ ]
  #   ++ lib.optionals stdenv.isDarwin [
  #   darwin.apple_sdk.frameworks.Accelerate
  #   darwin.apple_sdk.frameworks.CoreGraphics
  #   darwin.apple_sdk.frameworks.CoreVideo
  # ];

  # makeFlags = [
  #   "PREFIX=$(out)"
  # ];

  buildPhase = ''
    make helper
  '';


  installPhase = ''
    runHook preInstall

    install -Dm755 helper $out/bin/felixkratz-sketchybar-helper

    runHook postInstall
  '';

  meta = with lib; {
    description = "FelixKratz sketchybar helper";
    homepage = "https://github.com/FelixKratz/dotfiles";
    license = licenses.unlicense;
    platforms = platforms.darwin;
    maintainers = [ maintainers.rayandrew ];
  };

}
