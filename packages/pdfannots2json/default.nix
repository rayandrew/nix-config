{ pkgs
, buildGoModule
, buildGoPackage
, lib
, fetchFromGitHub
, ...
}:


buildGoPackage rec {
  pname = "pdfannots2json";
  version = "1.0.16";

  src = fetchFromGitHub {
    owner = "mgmeyers";
    repo = "pdfannots2json";
    rev = "${version}";
    sha256 = "sha256-qk4OSws/6SevN/Q0lsyxw+fZkm2uy1WwOYYL7CB7QUk=";
  };

  goPackagePath = "github.com/mgmeyers/pdfannots2json";

  vendorSha256 = null;

  nativeBuildInputs = [ ];

  CGO_ENABLED = 1;

  subPackages = [ "." ];
  ldflags = [
    "-linkmode external"
  ];

  buildPhase = ''
    cd go/src/${goPackagePath}
    patchShebangs .
    mkdir -p ./dist
    go build -trimpath -o ./dist/pdfannots2json .
  '';

  installPhase = ''
    # mkdir -p $out/bin
    # cp dist/pdfannots2json $out/bin/pdfannots2json

    install -Dm755 dist/* -t $out/bin
  '';

  meta = with lib; {
    description = "Extracts annotations from PDF and converts them to a JSON list.";
    homepage = "https://github.com/mgmeyers/pdfannots2json";
    license = licenses.gpl3;
    maintainers = with maintainers; [ rayandrew ];
  };
}
