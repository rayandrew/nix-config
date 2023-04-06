{ pkgs
, lib
, stdenv
, fetchFromGitHub
, darwin
, ...
}:

stdenv.mkDerivation rec {
  pname = "alpaca.cpp";
  version = "a0c74a70194284e943020cb43d8072a048aaeec5";

  src = fetchFromGitHub {
    owner = "antimatter15";
    repo = "${pname}";
    rev = version;
    sha256 = "sha256-1WyqOhq3MjnVevqgQALKE8+AvET1kQYo7wXuSG6ZpmE=";
  };

  nativeBuildInputs = [

  ];

  buildInputs = with pkgs; [ ]
    ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Accelerate
    darwin.apple_sdk.frameworks.CoreGraphics
  ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  # buildPhase = ''
  #   make chat 
  # '';

  installPhase = ''
    mkdir -p $out/bin
    cp chat $out/bin/alpaca-chat
  '';

  meta = with lib; {
    description = "Locally run an Instruction-Tuned Chat-Style LLM";
    homepage = "https://github.com/antimatter15/alpaca.cpp";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.rayandrew ];
  };

}
