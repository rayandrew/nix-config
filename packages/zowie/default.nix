{ pkgs
, lib
, stdenv
, fetchzip
, ...
}:

stdenv.mkDerivation rec {
  pname = "zowie";
  version = "1.3.0";

  src = fetchzip {
    url = "https://github.com/mhucka/zowie/releases/download/v1.3.0/zowie-1.3.0-macos-python3.10.zip";
    sha256 = "sha256-edNtmn9CVXrk6eWfqUUaArYe7cNRkrFjeG+4AaVUHMk=";
  };


  buildInputs = with pkgs; [
    python310
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 zowie $out/bin/zowie

    runHook postInstall
  '';
}

# pkgs.python311.pkgs.buildPythonApplication rec {
#   pname = "zowie";
#   version = "1.3.0";
#
#   src = pkgs.fetchFromGitHub {
#     owner = "mhucka";
#     repo = pname;
#     rev = "1cbd8dcaf21117ac42e2269711ed65a766323e55";
#     sha256 = "sha256-nFDcu0wONU+pQ5l4GXyJgopqcXxICdOkVUHPILjtLM8=";
#   };
#
#   buildInputs = with pkgs.python311Packages; [
#     aenum
#     biplist
#     boltons
#   ];
#
#   # By default tests are executed, but they need to be invoked differently for this package
#   dontUseSetuptoolsCheck = true;
# }
