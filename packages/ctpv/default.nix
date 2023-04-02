{ lib
, pkgs
, file
, openssl
, stdenv
, gcc12Stdenv
, fetchFromGitHub
, waylandSupport ? stdenv.isLinux
, x11Support ? stdenv.isLinux
}:

gcc12Stdenv.mkDerivation rec {
  pname = "ctpv";
  version = "4c14f6d393e3cc1fcbc1ec81574cfc028f95eea0";

  src = fetchFromGitHub {
    owner = "NikitaIvanovV";
    repo = "${pname}";
    rev = version;
    sha256 = "sha256-z7Sz9TxI0t4z4iindvDfVz0bIVC/V0gjukud1mSqtEc=";
  };

  nativeBuildInputs = [
    file # libmagic
    openssl
  ];

  buildInputs = with pkgs; [
    ffmpegthumbnailer
    ffmpeg
  ]
  ++ lib.optionals stdenv.isDarwin [ chafa ]
  ++ lib.optionals waylandSupport [ chafa ]
  ++ lib.optionals x11Support [ ueberzug ];

  makeFlags = [
    "PREFIX=$(out)"
    # "CC=gcc"
  ];

  preBuild = ''
    # export CC=gcc
    $CC --version
  '';

  meta = with lib; {
    description = "Image previews for lf (list files) file manager";
    homepage = "https://github.com/NikitaIvanovV/ctpv";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.wesleyjrz ];
  };
}
