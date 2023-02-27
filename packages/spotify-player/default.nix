{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, cmake
, alsa-lib
, dbus
, fontconfig
  # , libinotify-kqueue
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "spotify-player";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "aome510";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nWXXaRHTzCXmu4eKw88pKuWXgdG9n7azPeBbXYz+Fio=";
  };

  cargoHash = "sha256-y/qHiwZes4nVtjbFN/jL2LFugGpRKnYij7+XXZbqguQ=";

  nativeBuildInputs = [
    pkg-config
    cmake
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    dbus
    fontconfig
    # libinotify-kqueue
  ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.AudioUnit
    darwin.apple_sdk.frameworks.AudioToolbox
    darwin.apple_sdk.frameworks.CoreAudio
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.Carbon
    darwin.apple_sdk.frameworks.MediaPlayer
    darwin.apple_sdk.frameworks.Security
  ]
  ++ lib.optionals stdenv.isLinux [ alsa-lib ];

  buildNoDefaultFeatures = true;

  buildFeatures = [
    "rodio-backend"
    "media-control"
    "image"
    "lyric-finder"
    "streaming"
    # "notify"
  ];

  meta = with lib; {
    description = "A command driven spotify player";
    homepage = "https://github.com/aome510/spotify-player";
    mainProgram = "spotify_player";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
