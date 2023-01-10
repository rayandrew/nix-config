{ cmake, extra-cmake-modules, lib, stdenv, fetchFromGitHub, sqlite }:

let
  inherit (stdenv.hostPlatform) system;
  target = {
    "aarch64-darwin" = "arm64";
    "x86_64-darwin" = "x86";
  }.${system} or (throw "Unsupported system: ${system}");
in

stdenv.mkDerivation rec {
  pname = "sketchybar-shendy";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "fabianishere";
    repo = "pam_reattach";
    rev = "0fbdc4cebce66179cb2daee3d88944acd6cef505";
    sha256 = "1r2c9pkqghx53i7188mgyllvp09sd0vfw4rrlnhvscqqazh7ipzl";
  }; 

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  installPhase = ''
    ls *
  '';

  cmakeFlags = [ 
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_PREFIX_PATH=\"/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib/\""
  ];

  meta = with lib; {
    description = "PAM Reattach";
    homepage = "https://github.com/fabianishere/pam_reattach";
    platforms = platforms.darwin;
    maintainers = [ maintainers.rayandrew ];
    license = licenses.gpl3;
  };
}
