{ pkgs, lib, stdenv, fetchFromGitHub, memstreamHook, Carbon, Cocoa, SkyLight, objc4 }:

let
  inherit (stdenv.hostPlatform) system;
  target = {
    "aarch64-darwin" = "arm64";
    "x86_64-darwin" = "x86";
  }.${system} or (throw "Unsupported system: ${system}");
  DisplayServices = [
    "/System/Library/PrivateFrameworks/DisplayServices.framework/Versions/A/DisplayServices"
    # "/System/Library/PrivateFrameworks/DisplayServices.framework/DisplayServices"
    # "/System/Library/PrivateFrameworks/DisplayServices.framework"
  ];
in

stdenv.mkDerivation rec {
  pname = "sketchybar";
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SketchyBar";
    rev = "v2.13.2";
    sha256 = "10i364400kn3mycvscq4d7mfdp3zcdl84dfbb5q52p491gal7yhh";
  };

  buildInputs = [ Carbon Cocoa SkyLight objc4 DisplayServices ]
    ++ lib.optionals (stdenv.system == "x86_64-darwin") [ memstreamHook ];

  makeFlags = [
    target
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./bin/sketchybar $out/bin/sketchybar
  '';

  meta = with lib; {
    description = "A highly customizable macOS status bar replacement";
    homepage = "https://github.com/FelixKratz/SketchyBar";
    platforms = platforms.darwin;
    maintainers = [ maintainers.rayandrew ];
    license = licenses.gpl3;
  };
}
