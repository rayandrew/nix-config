{ pkgs
, lib
, stdenvNoCC
, fetchurl
, darwin
, ...
}:

stdenvNoCC.mkDerivation rec {
  pname = "SketchyVim";
  version = "1.0.10";

  src = fetchurl {
    url = "https://github.com/FelixKratz/SketchyVim/releases/download/v1.0.10/bundle_1.0.10.tgz";
    sha256 = "sha256-eYfD8IlO1eLhNzFnkrz4YcDHCGdlpaNY7NOb9CISVzs=";
  };

  # src = fetchFromGitHub {
  #   owner = "FelixKratz";
  #   repo = "${pname}";
  #   rev = "010426a";
  #   sha256 = "sha256-xb0Sx/mxKL2LDC2lfK4v3aMNumpW7izAtYmaogZL2Xw=";
  # };

  # nativeBuildInputs = with pkgs; [
  #   ncurses
  #   iconv
  # ];
  #
  # buildInputs = with pkgs; [
  #   darwin.apple_sdk.frameworks.Carbon
  #   darwin.apple_sdk.frameworks.Cocoa
  # ];
  #
  # makeFlags = [
  #   "PREFIX=$(out)"
  # ];

  # installPhase = ''
  #   mkdir -p $out/bin
  #   cp svim $out/bin/svim
  # '';

  installPhase = ''
    runHook preInstall

    install -Dm755 svim $out/bin/svim

    runHook postInstall
  '';

  meta = with lib; {
    description = "Adds all vim moves and modes to macOS text fields";
    homepage = "https://github.com/FelixKratz/SketchyVim";
    license = licenses.mit;
    # platforms = [ "aarch64-darwin" ];
    platforms = lib.platforms.darwin;
    maintainers = [ maintainers.rayandrew ];
  };

}
